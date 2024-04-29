class CreateValidations < ActiveRecord::Migration[7.0]
  def change
    create_table :validations do |t|
      t.integer :validation_type
      t.string :regex_pattern
      t.integer :value1
      t.integer :value2
      t.date :date1
      t.date :date2
      t.string :text_value
      t.string :list
      t.string :operator

      t.references :campaign_field, null: false, foreign_key: true

      t.timestamps
    end
  end
end
