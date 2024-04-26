class AddStatusToCalculatedFields < ActiveRecord::Migration[7.1]
  def change
    add_column :calculated_fields, :status, :integer
  end
end
