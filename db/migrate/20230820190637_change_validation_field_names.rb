class ChangeValidationFieldNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :validations, :date1, :value_date_start
    rename_column :validations, :date2, :value_date_end
    rename_column :validations, :text_value, :value_text

    rename_column :validations, :value1, :min_value
    rename_column :validations, :value2, :max_value

    add_column :validations, :value_integer, :integer
    add_column :validations, :value_date, :date

    remove_column :validations, :list
    remove_column :validations, :regex_pattern
  end
end
