class CampaignDistributionsController < ApplicationController
    before_action :authenticate_user!
    before_action :get_distribution, only: [:edit, :update, :show]
    before_action :set_campaign_distribution, only: [:edit, :update, :show]

    def edit

    end

    def update
        respond_to do |format|
            if @campaign_distribution.update(campaign_distribution_params)
                format.html { redirect_to campaign_distributions_path(@campaign_distribution.campaign), notice: 'Field mapping was successfully updated.' }
                format.json { render :show, status: :ok, location: @campaign_distribution }
            else
                format.html { render :edit }
                format.json { render json: @campaign_distribution.errors, status: :unprocessable_entity }
            end
        end
    end

    def show

    end

    def mapped_field
      @campaign = Campaign.find(params[:campaign_id])
      @distribution = Distribution.find(params[:distribution_id])
      @campaign_distribution = @campaign.campaign_distributions.find_by(distribution_id: @distribution.id)
      @index = params[:index]
      @mapped_field = @campaign_distribution.mapped_fields.build
      
      # respond_to do |format|
      #   format.turbo_stream
      #   format.html { redirect_to edit_distribution_campaign_distribution_path(@distribution, @campaign_distribution) }
      # end
    end


    private
    
    def get_distribution
      @distribution = Distribution.find(params[:distribution_id])
    end

    def set_campaign_distribution
      @campaign_distribution = @distribution.campaign_distributions.find(params[:id])
    end
  
    def campaign_distribution_params
      params.require(:campaign_distribution).permit(:template, :use_template, field_mapping: params[:campaign_distribution][:field_mapping]&.keys&.map { |key| key }&.flatten, mapped_fields_attributes: [:static_value, :id, :name, :campaign_field_id, :_destroy])
    end


end