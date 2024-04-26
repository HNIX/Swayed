class CreateFieldAssociations < ActiveRecord::Migration[7.1]
  def change
    create_table :field_associations do |t|
      t.references :field, null: false, foreign_key: true
      t.references :fieldable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
