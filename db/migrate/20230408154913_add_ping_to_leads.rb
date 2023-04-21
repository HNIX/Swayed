class AddPingToLeads < ActiveRecord::Migration[7.0]
  def change
    remove_reference :leads, :campaign_source
    add_reference :leads, :api_ping, index: true
  end
end
