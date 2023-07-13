class AddArchivedToVerticals < ActiveRecord::Migration[7.0]
  def change
    add_column :verticals, :archived, :boolean
  end
end
