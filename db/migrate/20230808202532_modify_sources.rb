class ModifySources < ActiveRecord::Migration[7.0]
  def change
    remove_column :sources, :payout_cap, :integer
    remove_column :sources, :ping_cap, :integer
    remove_column :sources, :payout_type, :string

    add_column :sources, :margin, :decimal
    add_column :sources, :minimum_acceptable_bid, :decimal
    add_column :sources, :integration_type, :string
  end
end
