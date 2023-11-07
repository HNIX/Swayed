class RemoveAccountIdFromFields < ActiveRecord::Migration[7.0]
  def change
    remove_reference :fields, :account, foreign_key: true
  end
end
