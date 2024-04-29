class AddCompanyToApiPing < ActiveRecord::Migration[7.0]
  def change
    remove_reference :api_pings, :affiliate

    add_reference :api_pings, :company, index: true
    add_reference :api_pings, :campaign, index: true
  end
end
