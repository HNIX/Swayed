class RemoveApiPingIdFromLeads < ActiveRecord::Migration[7.0]
  def change
    remove_column :leads, :api_ping_id, :uuid
  end
end
