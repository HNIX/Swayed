class AddPostOnlyToCampaignFields < ActiveRecord::Migration[7.0]
  def change
    add_column :campaign_fields, :post_only, :boolean, default: false
  end
end
