class AddNameToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :name, :string
  end
end
