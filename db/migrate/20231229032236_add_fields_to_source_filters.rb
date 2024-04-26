class AddFieldsToSourceFilters < ActiveRecord::Migration[7.1]
  def change
    add_column :source_filters, :operator, :string
    add_column :source_filters, :value, :string
    add_reference :source_filters, :campaign_field, null: false, foreign_key: true
  end
end
