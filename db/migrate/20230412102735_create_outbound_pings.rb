class CreateOutboundPings < ActiveRecord::Migration[7.0]
  def change
    create_table :outbound_pings do |t|
      t.boolean :accepted
      t.string :endpoint
      t.jsonb :headers
      t.string :host
      t.boolean :lead_posted
      t.text :request_body
      t.string :request_method
      t.jsonb :response
      t.boolean :test
      t.references :account, null: false, foreign_key: true
      t.belongs_to :campaign_distribution, null: false, foreign_key: true
      t.belongs_to :lead, null: false, foreign_key: true

      t.timestamps
    end
  end
end
