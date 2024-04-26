# app/services/calculated_field_evaluator.rb

class CalculatedFieldEvaluator
    def initialize(campaign, field_values)
      @campaign = campaign
      @field_values = field_values
      @calculator = Dentaku::Calculator.new
    end
  
    def evaluate
        @campaign.calculated_fields.where(status: 'active').each do |calculated_field|
            p calculated_field
            evaluate_formula(calculated_field, replace_field_names_with_values(calculated_field.clean_formula, @field_values))
        end

        @field_values
    end
  
    private
  
    def evaluate_formula(calculated_field, formula)
        begin
            p formula
            p "checking dependencies"
            missing_dependencies = @calculator.dependencies(formula)
        
            if missing_dependencies.any?
                calculated_field.log_error('missing_dependency', "Missing dependencies: #{missing_dependencies.join(', ')}")
                return
            end

            p "evaluating"

            evaluated_value = @calculator.evaluate(formula)
            @field_values[calculated_field.name] = evaluated_value
        rescue => e
            calculated_field.log_error('evaluation_error', "Evaluation error: #{e.message}")
        end
    end
    
    def log_activity(calculated_field, message, error_type)
        calculated_field.create_activity key: message, owner: @campaign
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

  end
  