class AddHeadersToApiPing < ActiveRecord::Migration[7.0]
  def change
    add_column :api_pings, :headers, :jsonb
    add_column :api_pings, :host, :string
    add_column :api_pings, :request_method, :string
  end
end
