class AddFieldsToApiRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :api_requests, :endpoint, :string
    add_column :api_requests, :method_type, :string
    add_column :api_requests, :source_ip, :string
    add_column :api_requests, :errors, :text
    add_column :api_requests, :api_key, :string
    add_column :api_requests, :headers, :jsonb
    add_column :api_requests, :request_time, :datetime
    change_column :api_requests, :direction, :integer, default: 0
  end
end
