class AddIndexToApiRequestsCreatedAt < ActiveRecord::Migration[7.1]
  def change
    add_index :api_requests, :created_at
  end
end
