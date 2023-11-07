class AddFieldsToDistributions < ActiveRecord::Migration[7.0]
  def change
    add_column :distributions, :request_format, :integer
    add_column :distributions, :request_method, :integer
    add_column :distributions, :headers, :boolean
    add_column :distributions, :request_body_all_fields, :boolean
    add_column :distributions, :conditional_logic_enabled, :boolean
  end
end
