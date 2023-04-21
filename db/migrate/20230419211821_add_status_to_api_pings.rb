class AddStatusToApiPings < ActiveRecord::Migration[7.0]
  def change
    add_column :api_pings, :status, :integer, default: 0
  end
end
