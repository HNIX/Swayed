class AddApiRequestIdToLeads < ActiveRecord::Migration[7.1]
  def change
    add_column :leads, :api_request_id, :uuid
    add_index :leads, :api_request_id
    # Uncomment the line below to add a foreign key constraint
    #add_foreign_key :leads, :api_requests
  end
end
