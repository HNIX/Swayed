class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :payment_terms
      t.string :billing_cycle
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :tax_id
      t.string :currency
      t.integer :payment_threshold
      t.string :status

      t.timestamps
    end
  end
end
