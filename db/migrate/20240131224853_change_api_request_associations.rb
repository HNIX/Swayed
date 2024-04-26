class ChangeApiRequestAssociations < ActiveRecord::Migration[7.1]
  def change
    remove_column :api_requests, :source_id, :integer
    remove_column :api_requests, :distribution_id, :integer
    remove_index :api_requests, :source_id if index_exists?(:api_requests, :source_id)
    remove_index :api_requests, :distribution_id if index_exists?(:api_requests, :distribution_id)

    add_reference :api_requests, :requestable, polymorphic: true, index: true
  end
end
