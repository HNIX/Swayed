class AddMonetaryFieldsToLeads < ActiveRecord::Migration[7.0]
  def change
    add_column :leads, :revenue_cents, :integer
    add_column :leads, :profit_cents, :integer
    add_column :leads, :bid_cents, :integer
  end
end
