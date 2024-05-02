class VerticalFieldsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vertical
  before_action :set_field, only: [:show, :edit, :update, :destroy, :move]

  def new
    @field = VerticalField.new
    @list_value = @field.list_values.build
    @modal_title = "Add a new field"
  end

  def create
    @field = @vertical.vertical_fields.new(field_params)
    if @field.save
      redirect_to vertical_fields_path(@vertical), notice: "Field was successfully created."
    else
      render :new
    end
  end

  def edit
    @list_value = @field.list_values.build
    @modal_title = "Edit field"
  end

  def index
    @fields = @vertical.vertical_fields.order(position: :asc)

    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
  end

  def update
    respond_to do |format|
      if @field.update(field_params)
        format.html { redirect_to vertical_fields_path(@vertical), notice: "Field was successfully updated." }
        format.json { render :show, status: :ok, location: @field }
      else
        format.html { render :edit }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @field.destroy
      redirect_to vertical_fields_path(@vertical), notice: "Field was successfully deleted."
    else
      redirect_to vertical_fields_path(@vertical), notice: "Error deleting field."
    end
  end

  def move
    @field.insert_at(params[:position].to_i)
  end

  def list_value
  end

  private

  def set_vertical
    @vertical = Vertical.find(params[:vertical_id]) if params[:vertical_id]
  end

  def set_field
    @field = @vertical.vertical_fields.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to vertical_fields_path(@vertical), notice: "Field not found."
  end

  def field_params
    params.require(:vertical_field).permit(:name, :data_type, :default_value,
      :position, :post_only, :hide, :is_pii,
      :example_value, :value_acceptance, :default_value, :notes, :phone_format, :min_value, :max_value,
      :required, list_values: [], list_values_attributes: [:list_value, :id, :_destroy])
  end
end
