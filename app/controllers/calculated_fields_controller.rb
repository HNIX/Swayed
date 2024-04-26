class CalculatedFieldsController < ApplicationController
    before_action :authenticate_user!
    before_action :get_campaign, except: [:index, :validate_formula]
    before_action :set_calculated_field, only: [:edit, :update, :destroy]

    def new
      @calculated_field = @campaign.calculated_fields.build
      @modal_title = "Add a new calculated_field"
    end
  
    def create
      @calculated_field = @campaign.calculated_fields.build(calculated_field_params)

      if @calculated_field.save
        redirect_to campaign_calculated_fields_path(@campaign), notice: 'Calculated Field was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @modal_title = "Edit Calculated Field"
    end
  
    def update
      respond_to do |format|
        if @calculated_field.update(calculated_field_params)
          format.html { redirect_to campaign_calculated_fields_path(@campaign), notice: 'Calculated Field was successfully updated.',
            status: :see_other }
          format.json { render :show, status: :ok, location: @calculated_field }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @calculated_field.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @calculated_field.destroy
      respond_to do |format|
        format.html { redirect_to campaign_path(@campaign), notice: 'Calculated Field was successfully removed.' }
        format.json { head :no_content }
      end
    end

    def index
      @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
      @pagy, @calculated_fields = filter_and_sort(@campaign ? @campaign.calculated_fields : CalculatedField.all)
    end

    def archive
      @calculated_field = CalculatedField.find(params[:id])
      @calculated_field.update(status: 'archived')
      redirect_to campaign_calculated_fields_path(@calculated_field.campaign), notice: 'Calculated Field was successfully archived.'
    end

    def activate
      @calculated_field = CalculatedField.find(params[:id])
      @calculated_field.update(status: 'active')
      redirect_to campaign_calculated_fields_path(@calculated_field.campaign), notice: 'Calculated Field was successfully archived.'
    end

    def pause
      @calculated_field = CalculatedField.find(params[:id])
      @calculated_field.update(status: 'paused')
      redirect_to campaign_calculated_fields_path(@calculated_field.campaign), notice: 'Calculated Field was successfully archived.'
    end

    def validate_formula
      formula = params[:formula]
      campaign_id = params[:campaign_id] # Assuming the campaign ID is passed in params
      campaign = Campaign.find(campaign_id)
      
      # Generate sample payload based on campaign fields
      sample_payload = campaign.generate_sample_payload
  
      calculator = Dentaku::Calculator.new

      stripped_formula = ActionView::Base.full_sanitizer.sanitize(formula)

      # Clean text
      clean_formula = stripped_formula.gsub('&nbsp;', '').gsub("\n", '').gsub('\"', "'").gsub('&amp;', "&").gsub('&gt;', ">").gsub('&lt;', "<")

      begin
        # Replace field names in the formula with sample values
        dependencies = calculator.dependencies(clean_formula)

        test_formula = replace_field_names_with_values(clean_formula, sample_payload)

        evaluated_value = calculator.evaluate(test_formula)
        render json: { valid: true, evaluated_value: evaluated_value }
      rescue Dentaku::ParseError, Dentaku::TokenizerError => e
        cleaned_error_message = e.message.gsub('Dentaku::AST::', '')
        render json: { valid: false, error: cleaned_error_message, formula: clean_formula }
      end
    end
    
  
    private
    
    def get_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    def set_calculated_field
      @calculated_field = @campaign.calculated_fields.find(params[:id])
    end
  
    def calculated_field_params
      params.require(:calculated_field).permit(:formula, :name, :status)
    end

    def replace_field_names_with_values(formula, field_values)
      regex = /\{\{([a-zA-Z0-9_]+)\}\}/
      formula.gsub(regex) do |match|
        field_name = match.match(regex)[1]
        field_value = field_values[field_name]
  
        if field_value.nil?
          match
        elsif field_value.is_a?(Integer)
          field_value.to_s
        else
          "\"#{field_value}\""
        end
      end
    end

    def filter_and_sort(fields)
      query_params = params.slice(:query, :count, :sort, :direction)
      fields = fields.search(query_params[:query]) if query_params[:query].present?
      pagy(apply_sorting(fields, query_params), items: query_params.fetch(:count, 5))
    end
  
    def apply_sorting(fields, query_params)
      sort_column = %w[name status].include?(query_params[:sort]) ? query_params[:sort] : "name"
      sort_direction = %w[asc desc].include?(query_params[:direction]) ? query_params[:direction] : "asc"
      fields.reorder("#{sort_column} #{sort_direction}")
    end

end
  