class AddTemplateToCampaignDistribution < ActiveRecord::Migration[7.1]
  def change
    add_column :campaign_distributions, :use_template, :boolean
  end
end
