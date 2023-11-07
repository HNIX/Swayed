class AddOptionToDistributions < ActiveRecord::Migration[7.0]
  def change
    add_column :distributions, :headers_option, :boolean
    add_column :distributions, :select_fields, :boolean
  end
end
