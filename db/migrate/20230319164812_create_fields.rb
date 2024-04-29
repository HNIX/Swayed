class CreateFields < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.string :name
      t.string :label
      t.string :data_type
      t.boolean :validated, default: false
      t.boolean :post_required, default: false
      t.boolean :ping_required, default: false
      t.boolean :hide, default: false
      t.belongs_to :vertical, null: false, foreign_key: true
      t.belongs_to :account, null: false, foreign_key: true

      t.timestamps
    end

    add_index :fields, [:name, :vertical_id], unique: true
    add_index :fields, [:label, :vertical_id], unique: true
  end
end
