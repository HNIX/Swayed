class AddBooleanToValidations < ActiveRecord::Migration[7.0]
  def change
    add_column :validations, :value_boolean, :boolean
  end
end
