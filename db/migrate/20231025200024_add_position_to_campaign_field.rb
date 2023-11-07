class AddPositionToCampaignField < ActiveRecord::Migration[7.0]
  def change
    add_column :campaign_fields, :position, :integer
    
    Campaign.all.each do |campaign|
      campaign.campaign_fields.order(:updated_at).each.with_index(1) do |cf, index|
        cf.update_column :position, index
      end
    end
  end
end
