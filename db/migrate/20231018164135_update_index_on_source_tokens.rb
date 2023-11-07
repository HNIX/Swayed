class UpdateIndexOnSourceTokens < ActiveRecord::Migration[7.0]
  def change
    # Remove the old index
    remove_index :source_tokens, :company_id

    # Rename the column
    rename_column :source_tokens, :company_id, :source_id

    # Add the new index
    add_index :source_tokens, :source_id

    # Add a new foreign key constraint on source_id
    add_foreign_key :source_tokens, :sources
  end
end
