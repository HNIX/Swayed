class CreateMappedFields < ActiveRecord::Migration[7.0]
  def change
    create_table :mapped_fields do |t|
      t.string :name
      t.string :static_value
      t.belongs_to :campaign_field, foreign_key: true
      t.belongs_to :campaign_distribution, null: false, foreign_key: true
      t.boolean :is_static, default: false

      t.timestamps
    end
  end
end
