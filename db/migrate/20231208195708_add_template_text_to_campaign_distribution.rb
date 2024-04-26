class AddTemplateTextToCampaignDistribution < ActiveRecord::Migration[7.1]
  def change
    add_column :campaign_distributions, :template, :text
  end
end
