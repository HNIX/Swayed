class AddFieldsToCampaignFields < ActiveRecord::Migration[7.1]
  def change
    add_column :campaign_fields, :value_acceptance, :integer
    add_column :campaign_fields, :list_values, :text, array: true, default: []
    add_column :campaign_fields, :min_value, :decimal
    add_column :campaign_fields, :max_value, :decimal
    add_column :campaign_fields, :default_value, :string
    add_column :campaign_fields, :required, :boolean, default: false
    remove_column :campaign_fields, :label, :string
    remove_column :campaign_fields, :ping_required, :boolean
    remove_column :campaign_fields, :post_required, :boolean
    remove_column :campaign_fields, :validated, :boolean
  end
end





