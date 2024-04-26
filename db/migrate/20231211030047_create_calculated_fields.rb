class CreateCalculatedFields < ActiveRecord::Migration[7.1]
  def change
    create_table :calculated_fields do |t|
      t.string :name
      t.string :formula
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
