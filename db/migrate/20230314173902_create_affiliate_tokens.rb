class CreateAffiliateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :affiliates do |t|
      t.jsonb :metadata, default: {}
      t.string :name
      t.string :email
      t.string :phone
      t.belongs_to :account, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end

    create_table :affiliate_tokens do |t|
      t.datetime :expires_at
      t.datetime :last_used_at
      t.jsonb :metadata, default: {}
      t.string :name
      t.string :token
      t.boolean :transient, default: false
      t.belongs_to :account, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.belongs_to :affiliate, foreign_key: true

      t.timestamps
    end

    add_index :affiliate_tokens, :token, unique: true
  end
end