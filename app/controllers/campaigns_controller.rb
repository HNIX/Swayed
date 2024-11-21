class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :logs]

  def index
    @campaigns = Campaign.all
    @campaigns = @campaigns.search(params[:query]) if params[:query].present?
    @pagy, @campaigns = pagy(apply_sorting(@campaigns), items: params.fetch(:count, 5))

    # Decorate the campaigns collection
    @campaigns = @campaigns.decorate
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @campaign.save
      session[:campaign_id] = @campaign.id
      redirect_to campaign_build_path(@campaign, :data_config)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @campaign.update(campaign_params)
      if nested_campaign_fields_present?
        redirect_to data_campaign_path(@campaign), notice: "Campaign fields were successfully updated."
      else
        redirect_to campaign_path(@campaign), notice: t(".updated")
      end

    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_path, status: :see_other, notice: t(".destroyed")
  end

  def field
    @target_element_id = params[:target_element_id]
  end

  def show    

    session[:date_range] = params[:date_range] if params[:date_range].present?
    session[:source] = params[:source] if params[:source].present?
    session[:distribution] = params[:distribution] if params[:distribution].present?
    
    time_back = session[:date_range].to_i
    start_date = time_back.hours.ago.to_date if time_back == 24
    start_date ||= time_back.days.ago.to_date if time_back > 0
    start_date ||= 7.days.ago.to_date  # Default case

    end_date = Date.today

    # Prepare a default hash with all dates set to zero
    # default_data = (start_date..end_date).map { |date| [date, 0] }.to_h
    
    # Start with all api_requests for the campaign
    api_requests = @campaign.api_requests

    # Adjust filtering to handle polymorphic association
    inbound_api_requests = api_requests.where(requestable_type: 'Source', requestable_id: session[:source]) if session[:source].present? 
    outbound_api_requests = api_requests.where(requestable_type: 'Distribution', requestable_id: session[:distribution]) if session[:distribution].present? 

    # Group and count api_requests by day within the given range
    @inbound_requests_by_date = inbound_api_requests&.group_by_day(:created_at, range: start_date..end_date)&.count
    @outbound_requests_by_date = outbound_api_requests&.group_by_day(:created_at, range: start_date..end_date)&.count


    @accepted_inbound_ping_count = inbound_api_requests.nil? ? 0 : inbound_api_requests&.where(created_at: start_date..end_date)&.count
    @outbound_ping_count = outbound_api_requests&.where(created_at: start_date..end_date)&.count

    
    @leads_count = @campaign.leads.where(created_at: start_date..end_date).count
    @total_revenue = @campaign.leads.where(created_at: start_date..end_date).sum(:revenue_cents)/100.0
    @total_profit = @campaign.leads.where(created_at: start_date..end_date).sum(:profit_cents)/100.0
  end 

  def logs
    search_api_requests
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:id]).decorate
  end

  def campaign_params
    params.require(:campaign).permit(:name, :status, :campaign_type, :description, :distribution_schedule_enabled,
      :distribution_method, :distribution_schedule_start_time, :distribution_schedule_end_time, :vertical_id,
      campaign_fields_attributes: [:position, :name, :label, :data_type, :id, :ping_required, :post_required, :post_only, :_destroy],
      distribution_schedule_days: [],
      distribution_ids: [])
  end

  def nested_campaign_fields_present?
    params[:campaign][:campaign_fields_attributes].present?
  end

  def apply_sorting(campaigns)
    sort_column = %w[name status campaign_type].include?(params[:sort]) ? params[:sort] : "name"
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    campaigns.reorder("#{sort_column} #{sort_direction}")
  end

  def search_api_requests
    # Ensure you have pagination set up, e.g., using kaminari or will_paginate gem
    @api_requests = @campaign.api_requests
    @api_requests = @api_requests.search_by_terms(params[:query]) if params[:query].present?
    @api_requests = @api_requests.where(source_id: params[:source_id]) if params[:source_id].present?
    @api_requests = @api_requests.where(distribution_id: params[:distribution_id]) if params[:distribution_id].present?
    @api_requests = @api_requests.where(direction: params[:direction]) if params[:direction].present?
    @api_requests = @api_requests.where(status: params[:status]) if params[:status].present?

    if params[:start_date].present? && params[:end_date].present?
      @api_requests = @api_requests.where("created_at >= ? AND created_at <= ?", params[:start_date], params[:end_date])
    end

    # Use Pagy for pagination
    @pagy, @api_requests = pagy(@api_requests, items: 10) # Adjust the number of items per page as needed
  end
end
