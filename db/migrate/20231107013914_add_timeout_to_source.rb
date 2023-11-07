class AddTimeoutToSource < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :timeout, :integer
  end
end
