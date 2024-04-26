class ChangeStatusDefaultOnDistributionFilters < ActiveRecord::Migration[7.1]
  def change
    change_column_default :distributions, :status, from: nil, to: 0
    change_column_default :distribution_filters, :status, from: nil, to: 0
  end
end
