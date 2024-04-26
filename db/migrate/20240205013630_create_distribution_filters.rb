class CreateDistributionFilters < ActiveRecord::Migration[7.1]
  def change
    create_table :distribution_filters do |t|
      t.boolean :apply_to_all
      t.jsonb :criteria
      t.string :name
      t.string :operator
      t.integer :status
      t.string :value
      t.references :campaign_field, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
