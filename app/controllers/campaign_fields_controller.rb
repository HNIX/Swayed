class CampaignFieldsController < ApplicationController
    before_action :authenticate_user!
    before_action :get_campaign
    before_action :set_field, only: [:show, :edit, :update, :destroy, :move]


    def new
      @field = @campaign.campaign_fields.build
    end
  
    def create
      
      @field = @campaign.campaign_fields.build(field_params)

      if @field.save
        redirect_to campaign_campaign_fields_path(@campaign), notice: 'Field was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @rule_set = @field.rule_set
      @rule_set.rules.build
    end
  
    def update
      respond_to do |format|
        if @field.update(field_params)
          format.html { redirect_to campaign_campaign_field_path(@campaign, @field), notice: 'Field was successfully updated.' }
          format.json { render :show, status: :ok, location: @field }
        else
          format.html { render :edit }
          format.json { render json: @field.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @field.destroy
      respond_to do |format|
        format.html { redirect_to campaign_campaign_fields_path(@campaign), notice: 'Field was successfully removed.' }
        format.json { head :no_content }
      end
    end

    def move
      @field.insert_at(params[:position].to_i)
    end

    def index
      @fields = @campaign.campaign_fields
    end

    def show
      @leads = @campaign.leads
      @lead_values = {}

      @leads.each do |lead|
        field_name = @campaign_field.name
        @lead_values[lead.id] = lead.send(field_name)
      end
    end
  
    private
    
    def get_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    def set_field
      @field = @campaign.campaign_fields.find(params[:id])
    end
  
    def field_params
      params.require(:campaign_field).permit(:data_type, :hide, :label, :name, :ping_required, :post_required, :validated, :is_pii, :example_value)
    end

end
  