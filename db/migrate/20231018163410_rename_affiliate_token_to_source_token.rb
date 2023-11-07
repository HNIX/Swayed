class RenameAffiliateTokenToSourceToken < ActiveRecord::Migration[7.0]
  def change
    rename_table :affiliate_tokens, :source_tokens
  end
end
