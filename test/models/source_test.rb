# == Schema Information
#
# Table name: sources
#
#  id                     :bigint           not null, primary key
#  budget                 :integer
#  description            :text
#  failure_redirect_url   :string
#  integration_type       :integer
#  landing_page_url       :string
#  margin                 :decimal(, )
#  minimum_acceptable_bid :decimal(, )
#  name                   :string
#  offer_type             :integer
#  payout                 :integer
#  payout_method          :integer
#  payout_structure       :integer
#  postback_url           :string
#  privacy_policy_url     :string
#  shared                 :boolean
#  status                 :integer          default("active")
#  success_redirect_url   :string
#  terms                  :string
#  timeout                :integer
#  tracking_url           :string
#  traffic_sources        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  campaign_id            :bigint           not null
#  company_id             :bigint           not null
#  unique_source_id       :string
#
# Indexes
#
#  index_sources_on_campaign_id  (campaign_id)
#  index_sources_on_company_id   (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (company_id => companies.id)
#
require "test_helper"

class SourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
