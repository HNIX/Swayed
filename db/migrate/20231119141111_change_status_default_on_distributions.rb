class ChangeStatusDefaultOnDistributions < ActiveRecord::Migration[7.1]
  def change
    change_column_default :distributions, :status, from: nil, to: 'draft'
  end
end
