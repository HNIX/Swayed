class AddLimitsToCampaignSource < ActiveRecord::Migration[7.0]
  def change
    add_column :campaign_sources, :daily_limit, :integer
    add_column :campaign_sources, :weekly_limit, :integer
    add_column :campaign_sources, :monthly_limit, :integer
  end
end
