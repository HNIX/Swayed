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
    @latest_requests = @campaign.api_requests.order(request_time: :desc).limit(6)
    @inbound_requests_count = @campaign.api_requests.where(direction: "inbound").count
    @accepted_ping_count = @campaign.api_requests.where(direction: "inbound", status: "accepted").count
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
