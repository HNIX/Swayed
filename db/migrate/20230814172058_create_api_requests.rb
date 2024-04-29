class CreateApiRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :api_requests, id: :uuid do |t|
      t.boolean :accepted
      t.boolean :lead_posted
      t.integer :price
      t.integer :direction
      t.jsonb :request_body
      t.jsonb :response_body
      t.integer :status
      t.boolean :test
      t.integer :response_code
      t.references :campaign, null: false, foreign_key: true
      t.references :source, foreign_key: true
      t.references :distribution, foreign_key: true

      t.timestamps
    end
  end
end
