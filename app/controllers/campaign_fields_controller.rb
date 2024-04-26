class CampaignFieldsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign
  before_action :set_field, only: %i[show edit update destroy move]

  def new
    @field = @campaign.campaign_fields.build
    @field.list_values.build
    @modal_title = "Add a New Campaign Field"
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
    @field.list_values.build
    @modal_title = "Edit Campaign Field"
  end

  def update
    if @field.update(field_params)
      redirect_to campaign_campaign_fields_path(@campaign), notice: 'Field was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @field.destroy
    redirect_to campaign_campaign_fields_path(@campaign), notice: 'Field was successfully removed.'
  end

  def move
    @field.insert_at(params[:position].to_i)
    head :ok
  end

  def index
    @fields = @campaign.campaign_fields.order(:position)

    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
    # @leads = @campaign.leads
    # @lead_values = {}

    # @leads.each do |lead|
    #   field_name = @field.name
    #   @lead_values[lead.id] = lead.send(field_name)
    # end

    respond_to do |format|
      format.json { render json: @field.operator_options.to_json }
      format.html
    end

  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def set_field
    @field = @campaign.campaign_fields.find(params[:id])
  end

  def field_params
    params.require(:campaign_field).permit(:data_type, :position, :post_only, :hide, :name, :is_pii, 
      :example_value, :value_acceptance, :default_value, :notes, :phone_format, :min_value, :max_value, 
      :required, list_values_attributes: [:list_value, :id, :_destroy])
  end
end
