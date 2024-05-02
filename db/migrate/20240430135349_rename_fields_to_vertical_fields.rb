class RenameFieldsToVerticalFields < ActiveRecord::Migration[7.1]
  def change
    rename_table :fields, :vertical_fields
  end
end
