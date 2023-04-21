class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.belongs_to :vertical, null: false, foreign_key: true
      t.belongs_to :account, null: false, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
