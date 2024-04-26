class UpdateSourceTokenAssociations < ActiveRecord::Migration[7.1]
  def up
    remove_index :source_tokens, :source_id if index_exists?(:source_tokens, :source_id)
    add_index :source_tokens, :source_id, unique: true
  end

  def down
    remove_index :source_tokens, :source_id if index_exists?(:source_tokens, :source_id, unique: true)
    add_index :source_tokens, :source_id
  end
end
