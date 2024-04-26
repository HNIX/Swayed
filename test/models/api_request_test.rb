# == Schema Information
#
# Table name: api_requests
#
#  id                :uuid             not null, primary key
#  accepted          :boolean
#  api_key           :string
#  direction         :integer          default("inbound")
#  endpoint          :string
#  headers           :jsonb
#  lead_posted       :boolean
#  method_type       :string
#  price             :integer
#  request_body      :jsonb
#  request_body_hash :string
#  request_errors    :text
#  request_time      :datetime
#  requestable_type  :string
#  response_body     :jsonb
#  response_code     :integer
#  source_ip         :string
#  status            :integer
#  test              :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  campaign_id       :bigint           not null
#  requestable_id    :bigint
#
# Indexes
#
#  index_api_requests_on_campaign_id        (campaign_id)
#  index_api_requests_on_request_body_hash  (request_body_hash)
#  index_api_requests_on_requestable        (requestable_type,requestable_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#
require "test_helper"

class ApiRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
