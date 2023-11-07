class AddExampleValueToField < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :example_value, :string
  end
end
