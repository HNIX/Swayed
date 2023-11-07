# == Schema Information
#
# Table name: affiliate_tokens
#
#  id           :bigint           not null, primary key
#  expires_at   :datetime
#  last_used_at :datetime
#  metadata     :jsonb
#  name         :string
#  token        :string
#  transient    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint
#  company_id   :bigint
#
# Indexes
#
#  index_affiliate_tokens_on_account_id  (account_id)
#  index_affiliate_tokens_on_company_id  (company_id)
#  index_affiliate_tokens_on_token       (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require "test_helper"

class SourceTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
