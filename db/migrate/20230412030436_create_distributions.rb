class CreateDistributions < ActiveRecord::Migration[7.0]
  def change
    create_table :distributions do |t|
      t.belongs_to :company, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :endpoint
      t.string :key
      t.integer :status

      t.timestamps
    end
  end
end
