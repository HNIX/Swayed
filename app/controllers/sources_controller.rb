class SourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: %i[new show create edit update destroy]
  before_action :set_source, only: %i[edit show update destroy]
  before_action :set_source_from_id, only: %i[archive activate pause]

  def new
    @source = @campaign.sources.build
    @companies = Company.all
    @modal_title = "Add a New Source"
  end

  def create
    @source = @campaign.sources.build(source_params)
    if @source.save
      redirect_to campaign_sources_path(@campaign), notice: "Source was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @modal_title = "Edit Source"
  end

  def update
    if @source.update(source_params)
      redirect_to campaign_sources_path(@campaign), notice: "Source was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @source.destroy
    redirect_to campaign_sources_path(@campaign), notice: "Source was successfully removed."
  end

  def index
    @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
    @pagy, @sources = filter_and_sort_sources(@campaign ? @campaign.sources : Source.all)
  end

  def show
  end

  # Dynamic method generation for archive, activate, and pause actions
  %i[archive activate pause].each do |action|
    define_method(action) do
      @source.update(status: action)
      redirect_to campaign_sources_path(@source.campaign), notice: "Source was successfully #{action}d."
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def set_source
    @source = Source.find(params[:id])
  end

  def set_source_from_id
    @source = @campaign.sources.find(params[:id])
  end

  def source_params
    permitted_attributes = [:payout_structure, :success_redirect_url, :failure_redirect_url, :timeout, :description, :name, :offer_type, :company_id, :terms, :status, :landing_page_url, :privacy_policy_url, :postback_url, :payout_method, :payout, :budget, :margin, :minimum_acceptable_bid]
    permitted_attributes += [:campaign_id, :integration_type] if action_name == "create"
    params.require(:source).permit(permitted_attributes)
  end

  def filter_and_sort_sources(sources)
    query_params = params.slice(:query, :count, :sort, :direction)
    sources = sources.search(query_params[:query]) if query_params[:query].present?
    pagy(apply_sorting(sources, query_params), items: query_params.fetch(:count, 5))
  end

  def apply_sorting(sources, query_params)
    sort_column = %w[name status].include?(query_params[:sort]) ? query_params[:sort] : "name"
    sort_direction = %w[asc desc].include?(query_params[:direction]) ? query_params[:direction] : "asc"
    sources.reorder("#{sort_column} #{sort_direction}")
  end
end
