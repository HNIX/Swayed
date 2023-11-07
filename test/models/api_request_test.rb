# == Schema Information
#
# Table name: api_requests
#
#  id              :uuid             not null, primary key
#  accepted        :boolean
#  api_key         :string
#  direction       :integer          default("inbound")
#  endpoint        :string
#  errors          :text
#  headers         :jsonb
#  lead_posted     :boolean
#  method_type     :string
#  price           :integer
#  request_body    :jsonb
#  request_time    :datetime
#  response_body   :jsonb
#  response_code   :integer
#  source_ip       :string
#  status          :integer
#  test            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  campaign_id     :bigint           not null
#  distribution_id :bigint
#  source_id       :bigint
#
# Indexes
#
#  index_api_requests_on_campaign_id      (campaign_id)
#  index_api_requests_on_distribution_id  (distribution_id)
#  index_api_requests_on_source_id        (source_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (distribution_id => distributions.id)
#  fk_rails_...  (source_id => sources.id)
#
require "test_helper"

class ApiRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
