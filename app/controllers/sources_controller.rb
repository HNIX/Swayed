class SourcesController < ApplicationController
    before_action :authenticate_user!
    before_action :get_campaign
    before_action :set_source, only: [:show, :edit, :update, :destroy]

    ITEMS_PER_PAGE = 7

    def new
      @source = @campaign.sources.build
      @companies = Company.all
    end
  
    def create
      
      @source = @campaign.sources.build(source_params)

      if @source.save
        redirect_to campaign_sources_path(@campaign), notice: 'Source was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end
  
    def update
      respond_to do |format|
        if @source.update(source_params)
          format.html { redirect_to campaign_source_path(@campaign, @source), notice: 'Source was successfully updated.' }
          format.json { render :show, status: :ok, location: @source }
        else
          format.html { render :edit }
          format.json { render json: @source.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @source.destroy
      respond_to do |format|
        format.html { redirect_to campaign_sources_path(@campaign), notice: 'Source was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def index
      @sources = @campaign.sources
    end
  
    private
    
    def get_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    def set_source
      @source = @campaign.sources.find(params[:id])
    end
  
    def source_params
      params.require(:source).permit(:name, :offer_type, :company_id, :terms, :status, :landing_page_url, :privacy_policy_url, 
        :postback_url, :payout_method, :payout, :budget, :margin, :minimum_acceptable_bid, :integration_type)
    end

end
  