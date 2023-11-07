class AddBaseToVerticals < ActiveRecord::Migration[7.0]
  def change
    add_column :verticals, :base, :boolean, default: false
  end
end
