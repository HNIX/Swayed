class AddVerticalToSources < ActiveRecord::Migration[7.0]
  def change
    add_reference :sources, :vertical, foreign_key: true
    add_column :sources, :offer_type, :integer
  end
end
