class AddDistributionFieldsToCampaign < ActiveRecord::Migration[7.0]
  def change
    add_column :campaigns, :distribution_method, :string
    add_column :campaigns, :distribution_schedule_enabled, :boolean
    add_column :campaigns, :distribution_schedule_start_time, :time
    add_column :campaigns, :distribution_schedule_end_time, :time
    add_column :campaigns, :distribution_schedule_days, :string, array: true, default: []
  end
end
