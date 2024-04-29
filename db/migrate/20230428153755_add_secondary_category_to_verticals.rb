class AddSecondaryCategoryToVerticals < ActiveRecord::Migration[7.0]
  def change
    remove_column :verticals, :name

    add_column :verticals, :secondary_category, :string
    add_column :verticals, :primary_category, :integer
  end
end
