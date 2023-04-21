class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.references :company, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.string :terms
      t.integer :status
      t.string :landing_page_url
      t.string :privacy_policy_url
      t.string :postback_url
      t.string :payout_method
      t.string :payout_type
      t.integer :payout
      t.integer :payout_cap
      t.integer :ping_cap
      t.integer :budget

      t.timestamps
    end
  end
end
