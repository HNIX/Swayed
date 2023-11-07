class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :logs]

  ITEMS_PER_PAGE = 7

  def index
    @campaigns = Campaign.all.sorted
    @verticals = Vertical.all
    @campaign = Campaign.new
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
      redirect_to campaign_path(@campaign, anchor: params[:button]), notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_path, status: :see_other, notice: t(".destroyed")
  end
  
  def field
  end

  def show
    time_periods = [7, 30]

    time_periods.each do |days|
      instance_variable_set("@total_leads_#{days}_days", @campaign.total_leads_last_n_days(days))
      instance_variable_set("@leads_prior_#{days}_days", @campaign.total_leads_last_n_days(days * 2) - instance_variable_get("@total_leads_#{days}_days"))
      
      instance_variable_set("@acceptance_rate_#{days}_days", @campaign.acceptance_rate_last_n_days(days))
      instance_variable_set("@acceptance_rate_prior_#{days}_days", @campaign.acceptance_rate_last_n_days(days * 2) - instance_variable_get("@acceptance_rate_#{days}_days"))
      
      instance_variable_set("@total_revenue_#{days}_days", @campaign.total_revenue_last_n_days(days))
      instance_variable_set("@total_revenue_prior_#{days}_days", @campaign.total_revenue_last_n_days(days * 2) - instance_variable_get("@total_revenue_#{days}_days"))
      
      instance_variable_set("@total_profit_#{days}_days", @campaign.total_profit_last_n_days(days))
      instance_variable_set("@total_profit_prior_#{days}_days", @campaign.total_profit_last_n_days(days * 2) - instance_variable_get("@total_profit_#{days}_days"))
    end

    @total_leads_all_time = @campaign.leads.count
    @acceptance_rate_all_time = @campaign.lead_acceptance_rate
    @total_revenue_all_time = @campaign.total_revenue
    @total_profit_all_time = @campaign.total_profit
  end

  def logs
    paginate_api_requests
    @permitted_params = params.permit(:current_page)
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :status, :campaign_type, :description, :distribution_schedule_enabled, 
    :distribution_method, :distribution_schedule_start_time, :distribution_schedule_end_time, :vertical_id, 
    campaign_fields_attributes: [:position, :name, :label, :data_type, :id, :ping_required, :post_required, :_destroy], 
    sources_attributes: [:id, :company_id, :budget, :description, :integration_type, :landing_page_url, :margin, :minimum_acceptable_bid, :name, :offer_type, :payout, :payout_method, :postback_url, :privacy_policy_url, :status, :terms], 
    campaign_distributions_attributes: [:id, :distribution_id, :_destroy, field_mapping: params[:campaign][:campaign_distributions_attributes]&.each_value&.map { |cd| cd[:field_mapping]&.keys }&.flatten],
    distribution_schedule_days: [], 
    distribution_ids: [], 
    distributions_attributes: [:id, :endpoint, :key, :name, :request_method, :request_format, :company_id]
    )
  end

  def paginate_api_requests
    total_pages = (@campaign.api_requests.count / ITEMS_PER_PAGE.to_f).ceil
    current_page = (params[:api_requests_page] || 1).to_i
    current_page = [1, [current_page, total_pages].min].max

    @api_requests = @campaign.api_requests.order(created_at: :desc).offset((current_page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    @api_requests_pagination = { current_page: current_page, total_pages: total_pages }
  end

end
