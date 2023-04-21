class CampaignSourcesController < ApplicationController
  
    def destroy
      @campaign_source = CampaignSource.find(params[:id])
      @campaign_source.destroy
      respond_to do |format|
        format.html { redirect_to campaign_path(@campaign_source.campaign), notice: 'Source association was successfully removed.' }
        format.json { head :no_content }
      end
    end
  
  end