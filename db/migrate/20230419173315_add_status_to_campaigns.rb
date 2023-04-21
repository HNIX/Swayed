class AddStatusToCampaigns < ActiveRecord::Migration[7.0]
  def change
    add_column :campaigns, :status, :integer, default: 0
    add_column :campaigns, :campaign_type, :integer, default: 0
  end
end
