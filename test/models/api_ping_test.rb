# == Schema Information
#
# Table name: api_pings
#
#  id                 :uuid
#  accepted           :boolean
#  action             :text
#  endpoint           :text
#  headers            :jsonb
#  host               :string
#  ip_address         :string
#  lead_posted        :boolean
#  post_params        :jsonb
#  price              :integer
#  request_body       :text
#  request_method     :string
#  response           :jsonb
#  status             :integer          default("pending")
#  test               :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint           not null
#  campaign_source_id :bigint
#
# Indexes
#
#  index_api_pings_on_account_id          (account_id)
#  index_api_pings_on_campaign_source_id  (campaign_source_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require "test_helper"

class ApiPingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
