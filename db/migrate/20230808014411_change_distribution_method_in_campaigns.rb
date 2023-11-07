class ChangeDistributionMethodInCampaigns < ActiveRecord::Migration[7.0]
  def change
    change_column :campaigns, :distribution_method, :integer, using: 'distribution_method::integer'
  end
end
