class SourceFiltersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_campaign, except: [:index]
  before_action :set_source_filter, only: [:edit, :update, :destroy]

  def new
    @source_filter = @campaign.source_filters.build
    @modal_title = "Add a new source filter"
  end

  def create
    @source_filter = @campaign.source_filters.build(source_filter_params)

    if @source_filter.save
      redirect_to campaign_source_filters_path(@campaign), notice: "Source filter was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @modal_title = "Edit Source Filter"
  end

  def update
    respond_to do |format|
      if @source_filter.update(source_filter_params)
        format.html {
          redirect_to campaign_source_filters_path(@campaign), notice: "Source filter was successfully updated.",
            status: :see_other
        }
        format.json { render :show, status: :ok, location: @source_filter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @source_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @source_filter.destroy
    respond_to do |format|
      format.html { redirect_to campaign_path(@campaign), notice: "Source filter was successfully removed." }
      format.json { head :no_content }
    end
  end

  def index
    if params[:campaign_id]
      # If scoped under a campaign
      # page = params[:page] || 1
      @campaign = Campaign.find(params[:campaign_id])

      @source_filters = @campaign.source_filters

    else
      # General index for all calculated_fields
      @source_filters = SourceFilter.all
    end
  end

  def archive
    @source_filter = SourceFilter.find(params[:id])
    @source_filter.update(status: "archived")
    redirect_to campaign_source_filters_path(@source_filter.campaign), notice: "Source filter was successfully archived."
  end

  def activate
    @source_filter = SourceFilter.find(params[:id])
    @source_filter.update(status: "active")
    redirect_to campaign_source_filters_path(@source_filter.campaign), notice: "Source filter was successfully archived."
  end

  def pause
    @source_filter = SourceFilter.find(params[:id])
    @source_filter.update(status: "paused")
    redirect_to campaign_source_filters_path(@source_filter.campaign), notice: "Source filter was successfully archived."
  end

  private

  def get_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def set_source_filter
    @source_filter = @campaign.source_filters.find(params[:id])
  end

  def source_filter_params
    params.require(:source_filter).permit(:apply_to_all, :status, :name, :campaign_field_id, :value, :operator, source_ids: [])
  end
end
