class CreateCampaignDistributions < ActiveRecord::Migration[7.0]
  def change
    create_table :campaign_distributions do |t|
      t.belongs_to :campaign, null: false, foreign_key: true
      t.belongs_to :distribution, null: false, foreign_key: true
      t.integer :weekly_limit
      t.integer :daily_limit
      t.integer :monthly_limit

      t.timestamps
    end
  end
end
