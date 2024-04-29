class ChangeApiPingIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :api_pings, :uuid, :uuid, default: "uuid_generate_v4()"
    remove_column :api_pings, :id
    rename_column :api_pings, :uuid, :id
  end
end
