class AddRequestBodyHashToApiRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :api_requests, :request_body_hash, :string
    add_index :api_requests, :request_body_hash
  end
end
