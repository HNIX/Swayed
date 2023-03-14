class CreateLeads < ActiveRecord::Migration[7.0]
  def change
    create_table :leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.jsonb :custom_fields, default: {}, null: false
      t.integer :status, default: 0
      t.integer :score
      t.integer :account_id

      t.timestamps
    end
  end
end
