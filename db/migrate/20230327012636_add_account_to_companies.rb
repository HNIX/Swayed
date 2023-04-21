class AddAccountToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_reference :companies, :account, index: true
  end
end
