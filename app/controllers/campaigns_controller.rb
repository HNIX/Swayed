class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]
  before_action :set_campaign_id, only: [:inbound, :outbound, :connections, :settings]
  before_action :count_pings, only: [:show, :inbound, :outbound]

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
      redirect_to campaign_path(@campaign), notice: t(".created")
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
  end

  def connections
    @companies = Company.all
    @sources = Source.all #- form.object.sources
    @distributions = Distribution.all
  end

  def inbound
    paginate_api_pings
    @permitted_params = params.permit(:current_page)
  end

  def outbound
    paginate_outbound_pings
    @permitted_params = params.permit(:current_page)
  end

  def settings

  end

  def create_source
    @campaign = Campaign.find(params[:id])
    @source = Source.new(source_params)
    
    if @source.save
      @campaign.sources << @source
      redirect_to campaign_path(@campaign), notice: 'Source created and associated successfully.'
    else
      render 'campaigns/show'
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def set_campaign_id
    @campaign = Campaign.find(params[:campaign_id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :vertical_id, campaign_fields_attributes: [:name, :label, :data_type, :id, :ping_required, :post_required], campaign_sources_attributes: [:id, :source_id, :_destroy, :daily_limit, :weekly_limit, :monthly_limit], campaign_distributions_attributes: [:id, :distribution_id, :_destroy, field_mapping: params[:campaign][:campaign_distributions_attributes]&.each_value&.map { |cd| cd[:field_mapping]&.keys }&.flatten])
  end

  def source_params
    params.require(:source).permit(:landing_page_url, :post_back_url, :budget, :payout, :company_id)
  end

  def count_pings
    current_month_start = Date.today.beginning_of_month
    previous_month_start = current_month_start - 1.month
  
    @current_month_inbound = @campaign.api_pings.where('api_pings.created_at >= ?', current_month_start).count
    @previous_month_inbound = @campaign.api_pings.where('api_pings.created_at >= ? AND api_pings.created_at < ?', previous_month_start, current_month_start).count

    @current_month_outbound = @campaign.outbound_pings.where('outbound_pings.created_at >= ?', current_month_start).count
    @previous_month_outbound = @campaign.outbound_pings.where('outbound_pings.created_at >= ? AND outbound_pings.created_at < ?', previous_month_start, current_month_start).count

    @mom_inbound = @current_month_inbound - @previous_month_inbound
    @mom_outbound = @current_month_outbound - @previous_month_outbound
  end

  def paginate_api_pings
    total_pages = (@campaign.api_pings.count / ITEMS_PER_PAGE.to_f).ceil
    current_page = (params[:api_pings_page] || 1).to_i
    current_page = [1, [current_page, total_pages].min].max

    @api_pings = @campaign.api_pings.order(created_at: :desc).offset((current_page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    @api_pings_pagination = { current_page: current_page, total_pages: total_pages }
  end

  def paginate_outbound_pings
    total_pages = (@campaign.outbound_pings.count / ITEMS_PER_PAGE.to_f).ceil
    current_page = (params[:outbound_page] || 1).to_i
    current_page = [1, [current_page, total_pages].min].max

    @outbound_pings = @campaign.outbound_pings.order(created_at: :desc).offset((current_page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    @outbound_pagination = { current_page: current_page, total_pages: total_pages }
  end

end
