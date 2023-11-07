class AddIndexToSourceTokensName < ActiveRecord::Migration[7.0]
  def change
    add_index :source_tokens, :name, unique: true
  end
end
