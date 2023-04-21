class CreateVerticals < ActiveRecord::Migration[7.0]
  def change
    create_table :verticals do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
