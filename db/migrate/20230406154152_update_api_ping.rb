class UpdateApiPing < ActiveRecord::Migration[7.0]
  def change
    add_column :api_pings, :accepted, :boolean
    add_column :api_pings, :lead_posted, :boolean
    add_column :api_pings, :test, :boolean
    add_column :api_pings, :ip_address, :string
    add_column :api_pings, :price, :integer
    add_column :api_pings, :response, :jsonb
    add_column :api_pings, :post_params, :jsonb
  end
end
