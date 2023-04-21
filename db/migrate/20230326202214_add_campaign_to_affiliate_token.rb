class AddCampaignToAffiliateToken < ActiveRecord::Migration[7.0]
  def change
    remove_reference :affiliate_tokens, :user
    remove_reference :affiliate_tokens, :affiliate
  

    add_reference :affiliate_tokens, :company, index: true

  end
end
