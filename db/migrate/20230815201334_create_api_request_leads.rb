class CreateApiRequestLeads < ActiveRecord::Migration[7.0]
  def change
    create_table :api_request_leads do |t|
      t.references :api_request, null: false, foreign_key: true, type: :uuid
      t.references :lead, null: false, foreign_key: true

      t.timestamps
    end
  end
end
