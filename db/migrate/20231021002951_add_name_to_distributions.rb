class AddNameToDistributions < ActiveRecord::Migration[7.0]
  def change
    add_column :distributions, :name, :string
  end
end
