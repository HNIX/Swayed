class CreateCampaignSources < ActiveRecord::Migration[7.0]
  def change
    create_table :campaign_sources do |t|
      t.belongs_to :campaign, null: false, foreign_key: true
      t.belongs_to :source, null: false, foreign_key: true

      t.timestamps
    end
  end
end
