class ValidationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_field
  before_action :set_validation, only: [:show, :edit, :update, :destroy]
  before_action :set_validation_types, only: [:new, :edit]

  def new
    @validation = @field.validations.build validation_params
  end

  def create
    @validation = @field.validations.build(validation_params)

    if @validation.save
      redirect_to campaign_field_validations_path(@field), notice: "Validation was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @validation.update(validation_params)
        format.html { redirect_to campaign_field_validation_path(@field, @validation), notice: "Validation was successfully updated." }
        format.json { render :show, status: :ok, location: @validation }
      else
        format.html { render :edit }
        format.json { render json: @validation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @validation.destroy
    respond_to do |format|
      format.html { redirect_to campaign_field_validations_path(@field), notice: "Validation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def index
    @validations = @field.validations
  end

  def options
    respond_to do
      format.turbo_stream
    end
  end

  private

  def get_field
    @field = CampaignField.find(params[:campaign_field_id])
  end

  def set_validation
    @validation = @field.validations.find(params[:id])
  end

  def validation_params
    params.fetch(:validation, {}).permit(:min_value, :max_value, :operator, :value_text, :validation_type, :value_boolean, :value_date, :value_date_start, :value_date_end, :value_integer)
  end

  def set_validation_types
    @validation_types = case @field.data_type
    when "date"
      Validation.validation_types.slice(:presence, :date)
    when "text"
      Validation.validation_types.slice(:presence, :format, :value_length, :text_value)
    when "number"
      Validation.validation_types.slice(:presence, :number_value)
    when "boolean"
      Validation.validation_types.slice(:presence, :value)
    else
      Validation.validation_types
    end
  end
end
