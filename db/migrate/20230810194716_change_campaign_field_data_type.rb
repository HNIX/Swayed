class ChangeCampaignFieldDataType < ActiveRecord::Migration[7.0]
  def change
    change_column :campaign_fields, :data_type, :integer, using: "data_type::integer"
  end
end
