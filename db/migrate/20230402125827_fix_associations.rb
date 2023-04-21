class FixAssociations < ActiveRecord::Migration[7.0]
  def change
    remove_reference :api_pings, :campaign
    remove_reference :api_pings, :company
    add_reference :api_pings, :campaign_source, index: true

    add_reference :leads, :campaign_source, index: true

    remove_reference :sources, :campaign
  end
end
