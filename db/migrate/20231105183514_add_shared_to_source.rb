class AddSharedToSource < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :shared, :boolean
  end
end
