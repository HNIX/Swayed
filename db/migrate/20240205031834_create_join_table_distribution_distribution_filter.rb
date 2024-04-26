class CreateJoinTableDistributionDistributionFilter < ActiveRecord::Migration[7.1]
  def change
    create_join_table :distributions, :distribution_filters do |t|
      t.index [:distribution_id, :distribution_filter_id]
      t.index [:distribution_filter_id, :distribution_id]
    end
  end
end
