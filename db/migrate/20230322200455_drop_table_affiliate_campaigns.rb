class DropTableAffiliateCampaigns < ActiveRecord::Migration[7.0]
  def change
    drop_table :affiliate_campaigns
  end
end
