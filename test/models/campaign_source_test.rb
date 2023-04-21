# == Schema Information
#
# Table name: campaign_sources
#
#  id            :bigint           not null, primary key
#  daily_limit   :integer
#  monthly_limit :integer
#  weekly_limit  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  campaign_id   :bigint           not null
#  source_id     :bigint           not null
#
# Indexes
#
#  index_campaign_sources_on_campaign_id  (campaign_id)
#  index_campaign_sources_on_source_id    (source_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (source_id => sources.id)
#
require "test_helper"

class CampaignSourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
