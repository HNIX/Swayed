class CreateListValues < ActiveRecord::Migration[7.1]
  def change
    create_table :list_values do |t|
      t.integer :integer_value
      t.string :string_value
      t.integer :value_type
      t.references :campaign_field, null: false, foreign_key: true

      t.timestamps
    end
  end
end
