class DistributionsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_campaign, only: [:new, :edit, :show, :create, :update, :destroy]
  before_action :set_distribution, only: [:show, :edit, :update, :destroy]

  def new
    @distribution = @campaign.distributions.build
    @companies = Company.all
    @modal_title = "Add a new distribution"
  end

  def create
    @distribution = @campaign.distributions.build(distribution_params)

    if @distribution.save
      @campaign.distributions << @distribution
      redirect_to campaign_distributions_path(@campaign), notice: "Distribution was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @modal_title = "Edit Distribution"
  end

  def update
    respond_to do |format|
      if @distribution.update(distribution_params)
        format.html { redirect_to campaign_distributions_path(@campaign), notice: "Distribution was successfully updated." }
        format.json { render :show, status: :ok, location: @distribution }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @distribution.destroy
    respond_to do |format|
      format.html { redirect_to campaign_distributions_path(@campaign), notice: "Distribution was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def index
    @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
    @pagy, @distributions = filter_and_sort(@campaign ? @campaign.distributions : Distribution.all)
  end

  def header
  end

  private

  def get_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def set_distribution
    @distribution = @campaign.distributions.find(params[:id])
    @campaign_distribution = @distribution.campaign_distributions.where(campaign: @campaign).first
  end

  def distribution_params
    params.require(:distribution).permit(:name, :request_method, :request_format, :company_id, :endpoint, :key, :response_format, :status, response_mapping: [:bid, :status, :message], campaign_distributions_attributes: [:id, :distribution_id, :_destroy, field_mapping: params[:distribution][:campaign_distributions_attributes]&.each_value&.map { |cd| cd[:field_mapping]&.keys }&.flatten])
  end

  def filter_and_sort(distributions)
    query_params = params.slice(:query, :count, :sort, :direction)
    distributions = distributions.search(query_params[:query]) if query_params[:query].present?
    pagy(apply_sorting(distributions, query_params), items: query_params.fetch(:count, 5))
  end

  def apply_sorting(distributions, query_params)
    sort_column = %w[name status].include?(query_params[:sort]) ? query_params[:sort] : "name"
    sort_direction = %w[asc desc].include?(query_params[:direction]) ? query_params[:direction] : "asc"
    distributions.reorder("#{sort_column} #{sort_direction}")
  end
end
