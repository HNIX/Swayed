class AddFieldMappingToCampaignDistributions < ActiveRecord::Migration[7.0]
  def change
    add_column :distributions, :template, :jsonb
    add_column :campaign_distributions, :field_mapping, :jsonb
  end
end
