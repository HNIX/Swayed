class CreateSourceFilters < ActiveRecord::Migration[7.1]
  def change
    create_table :source_filters do |t|
      t.jsonb :criteria, null: false, default: '{}'
      t.string :name
      t.integer :status, default: 0
      t.boolean :apply_to_all, default: false
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end

    create_join_table :sources, :source_filters do |t|
      t.index :source_id
      t.index :source_filter_id
    end
  end
end
