class RemoveLimitsFromCampaignFields < ActiveRecord::Migration[7.0]
  def change
    remove_column :campaign_distributions, :daily_limit, :integer
    remove_column :campaign_distributions, :monthly_limit, :integer
    remove_column :campaign_distributions, :weekly_limit, :integer
  end
end
