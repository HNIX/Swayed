# == Schema Information
#
# Table name: source_tokens
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
#  source_id    :bigint
#
# Indexes
#
#  index_source_tokens_on_account_id  (account_id)
#  index_source_tokens_on_name        (name) UNIQUE
#  index_source_tokens_on_source_id   (source_id) UNIQUE
#  index_source_tokens_on_token       (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (source_id => sources.id)
#
require "test_helper"

class SourceTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
