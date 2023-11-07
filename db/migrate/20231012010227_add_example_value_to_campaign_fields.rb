class AddExampleValueToCampaignFields < ActiveRecord::Migration[7.0]
  def change
    add_column :campaign_fields, :example_value, :string
  end
end
