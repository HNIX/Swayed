# == Schema Information
#
# Table name: outbound_pings
#
#  id                       :bigint           not null, primary key
#  accepted                 :boolean
#  endpoint                 :string
#  headers                  :jsonb
#  host                     :string
#  lead_posted              :boolean
#  request_body             :text
#  request_method           :string
#  response                 :jsonb
#  test                     :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  account_id               :bigint           not null
#  campaign_distribution_id :bigint           not null
#  lead_id                  :bigint           not null
#
# Indexes
#
#  index_outbound_pings_on_account_id                (account_id)
#  index_outbound_pings_on_campaign_distribution_id  (campaign_distribution_id)
#  index_outbound_pings_on_lead_id                   (lead_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (campaign_distribution_id => campaign_distributions.id)
#  fk_rails_...  (lead_id => leads.id)
#
require "test_helper"

class OutboundPingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
