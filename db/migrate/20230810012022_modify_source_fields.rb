class ModifySourceFields < ActiveRecord::Migration[7.0]
  def change
    change_column :sources, :integration_type, :integer, using: "integration_type::integer"
    change_column :sources, :payout_method, :integer, using: "payout_method::integer"
  end
end
