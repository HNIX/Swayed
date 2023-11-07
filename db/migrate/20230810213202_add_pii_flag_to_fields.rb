class AddPiiFlagToFields < ActiveRecord::Migration[7.0]
  def change
    add_column :campaign_fields, :is_pii, :boolean
  end
end
