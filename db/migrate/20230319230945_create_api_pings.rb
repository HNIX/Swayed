class CreateApiPings < ActiveRecord::Migration[7.0]
  def change
    create_table :api_pings do |t|
      t.references :account, null: false, foreign_key: true
      t.text :request_body
      t.references :affiliate, foreign_key: true
      t.text :endpoint
      t.text :action

      t.timestamps
    end
  end
end
