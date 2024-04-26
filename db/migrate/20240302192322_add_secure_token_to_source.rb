class AddSecureTokenToSource < ActiveRecord::Migration[7.1]
  def change
    add_column :sources, :secure_token, :string
    add_index :sources, :secure_token, unique: true
  end
end
