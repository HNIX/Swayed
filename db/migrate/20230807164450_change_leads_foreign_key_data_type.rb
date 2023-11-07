class ChangeLeadsForeignKeyDataType < ActiveRecord::Migration[7.0]
  def up
    # Add a new UUID column
    add_column :leads, :temp_uuid_api_ping_id, :uuid

    # Populate the new column with the UUID value converted from the bigint column
    Lead.all.each do |lead|
      lead.update_column(:temp_uuid_api_ping_id, lead.api_ping_id)
    end

    # Remove the old bigint column
    remove_column :leads, :api_ping_id

    # Rename the new column to match the old column name
    rename_column :leads, :temp_uuid_api_ping_id, :api_ping_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
