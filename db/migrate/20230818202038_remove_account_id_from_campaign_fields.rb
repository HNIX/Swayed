class RemoveAccountIdFromCampaignFields < ActiveRecord::Migration[7.0]
  def change
    remove_reference :campaign_fields, :account, foreign_key: true
  end
end
