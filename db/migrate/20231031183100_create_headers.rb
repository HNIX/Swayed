class CreateHeaders < ActiveRecord::Migration[7.0]
  def change
    create_table :headers do |t|
      t.string :name
      t.string :header_value
      t.references :distribution, foreign_key: true

      t.timestamps
    end
  end
end
