class CreateCampaignFields < ActiveRecord::Migration[7.0]
  def change
    create_table :campaign_fields do |t|
      t.string :name
      t.string :label
      t.string :data_type
      t.boolean :validated
      t.boolean :post_required
      t.boolean :ping_required
      t.boolean :hide
      t.belongs_to :campaign, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
