class AddOptionsToSource < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :payout_structure, :integer
    add_column :sources, :unique_source_id, :string
    add_column :sources, :traffic_sources, :integer
    add_column :sources, :tracking_url, :string
  end
end
