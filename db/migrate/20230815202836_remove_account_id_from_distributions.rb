class RemoveAccountIdFromDistributions < ActiveRecord::Migration[7.0]
  def change
    remove_column :distributions, :account_id, :integer
  end
end
