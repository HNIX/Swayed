class AddFieldsToFields < ActiveRecord::Migration[7.1]
  def change
    add_column :fields, :default_value, :string
    add_column :fields, :is_pii, :boolean
    add_column :fields, :max_value, :integer
    add_column :fields, :min_value, :integer
    add_column :fields, :position, :integer
    add_column :fields, :post_only, :boolean, default: false
    add_column :fields, :required, :boolean, default: false
    add_column :fields, :value_acceptance, :integer
    remove_column :fields, :label
    remove_column :fields, :ping_required
    remove_column :fields, :post_required
    
  end
end