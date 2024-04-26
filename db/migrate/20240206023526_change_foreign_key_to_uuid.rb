class ChangeForeignKeyToUuid < ActiveRecord::Migration[7.1]
  def change
    remove_column :api_request_leads, :api_request_id, :integer
    add_column :api_request_leads, :api_request_id, :uuid
    add_index :api_request_leads, :api_request_id
  end
end
