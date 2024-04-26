class RemoveListValuesFromCampaignFields < ActiveRecord::Migration[7.1]
  def change
    remove_column :campaign_fields, :list_values, :string
  end
end
