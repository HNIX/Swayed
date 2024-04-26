class FieldsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_context
    before_action :set_field, only: [:show, :edit, :update, :destroy, :move]
  
    def new
      @field = Field.new
      @list_value = @field.list_values.build
      @modal_title = "Add a new field"
    end

  
    def create
      @field = @context.fields.new(field_params)
      if @field.save
        redirect_based_on_context(@context, notice: 'Field was successfully created.')
      else
        render :new
      end
    end
  
    def edit
      @list_value = @field.list_values.build
      @modal_title = "Edit field"
    end

    def index
        @fields = @context.fields.order(position: :asc)

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
                format.html { redirect_based_on_context(@context, notice: 'Field was successfully updated.') }
                format.json { render :show, status: :ok, location: @field }
            else
                format.html { render :edit }
                format.json { render json: @field.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        if @field.destroy
            redirect_based_on_context(@context, notice: 'Field was successfully deleted.')
        else
            redirect_based_on_context(@context, alert: 'Error deleting field.')
        end
    end

    def move
        @field.insert_at(params[:position].to_i)
    end

    def list_value

    end
  
    private
  
    def set_context
      @context = Vertical.find(params[:vertical_id]) if params[:vertical_id]
      @context ||= Campaign.find(params[:campaign_id]) if params[:campaign_id]
    end

    def set_field
        @field = @context.fields.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_based_on_context(@context, notice: 'Field not found.')
    end
  
    def field_params
      params.require(:field).permit(:name, :data_type, :default_value)
      # Add other field attributes as needed

        :position, :post_only, :hide, :is_pii, 
        :example_value, :value_acceptance, :default_value, :notes, :phone_format, :min_value, :max_value, 
        :required, list_values: [], list_values_attributes: [:list_value, :id, :_destroy])
    end


    def redirect_based_on_context(context, flash_message)
        if context.is_a?(Campaign)
            redirect_to campaign_fields_path(context), flash_message
        elsif context.is_a?(Vertical)
            redirect_to vertical_fields_path(context), flash_message
        else
            # Handle unexpected context
            redirect_to root_path, alert: 'Unexpected context.'
        end
    end

end
