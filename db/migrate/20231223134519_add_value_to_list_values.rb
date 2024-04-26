class AddValueToListValues < ActiveRecord::Migration[7.1]
  def change
    add_column :list_values, :list_value, :string
    change_column_default :list_values, :value_type, from: nil, to: 0
    remove_column :list_values, :integer_value, :integer
    remove_column :list_values, :string_value, :string
  end
end
