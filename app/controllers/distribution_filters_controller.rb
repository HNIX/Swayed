class DistributionFiltersController < ApplicationController
    before_action :authenticate_user!
    before_action :get_campaign, except: [:index]
    before_action :set_distribution_filter, only: [:edit, :update, :destroy]

    def new
      @distribution_filter = @campaign.distribution_filters.build
      @modal_title = "Add a new distribution filter"
    end
  
    def create
      @distribution_filter = @campaign.distribution_filters.build(distribution_filter_params)

      if @distribution_filter.save
        redirect_to campaign_distribution_filters_path(@campaign), notice: 'Distribution filter was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @modal_title = "Edit Distribution Filter"
    end
  
    def update
      respond_to do |format|
        if @distribution_filter.update(distribution_filter_params)
          format.html { redirect_to campaign_distribution_filters_path(@campaign), notice: 'Distribution filter was successfully updated.',
            status: :see_other }
          format.json { render :show, status: :ok, location: @distribution_filter }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @distribution_filter.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @distribution_filter.destroy
      respond_to do |format|
        format.html { redirect_to campaign_path(@campaign), notice: 'Distribution filter was successfully removed.' }
        format.json { head :no_content }
      end
    end

    def index      
      if params[:campaign_id]
        # If scoped under a campaign
        page = params[:page] || 1
        @campaign = Campaign.find(params[:campaign_id])

        @distribution_filters = @campaign.distribution_filters

      else
        # General index for all calculated_fields
        @distribution_filters = DistributionFilter.all
      end
    end

    def archive
      @distribution_filter = DistributionFilter.find(params[:id])
      @distribution_filter.update(status: 'archived')
      redirect_to campaign_distribution_filters_path(@distribution_filter.campaign), notice: 'Distribution filter was successfully archived.'
    end

    def activate
      @distribution_filter = DistributionFilter.find(params[:id])
      @distribution_filter.update(status: 'active')
      redirect_to campaign_distribution_filters_path(@distribution_filter.campaign), notice: 'Distribution filter was successfully archived.'
    end

    def pause
      @distribution_filter = DistributionFilter.find(params[:id])
      @distribution_filter.update(status: 'paused')
      redirect_to campaign_distribution_filters_path(@distribution_filter.campaign), notice: 'Distribution filter was successfully archived.'
    end
  
    private
    
    def get_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    def set_distribution_filter
      @distribution_filter = @campaign.distribution_filters.find(params[:id])
    end
  
    def distribution_filter_params
      params.require(:distribution_filter).permit(:apply_to_all, :status, :name, :campaign_field_id, :value, :operator, distribution_ids: [])
    end

end
  