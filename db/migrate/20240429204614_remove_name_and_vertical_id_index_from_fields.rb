class RemoveNameAndVerticalIdIndexFromFields < ActiveRecord::Migration[7.1]
  def change
    remove_index :fields, name: "index_fields_on_name_and_vertical_id"
    add_index :fields, :name, unique: true
  end
end
