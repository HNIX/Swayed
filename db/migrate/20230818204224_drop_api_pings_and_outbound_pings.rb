class DropApiPingsAndOutboundPings < ActiveRecord::Migration[7.0]
  def up
    drop_table :api_pings
    drop_table :outbound_pings
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
