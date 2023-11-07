# == Schema Information
#
# Table name: campaign_distributions
#
#  id              :bigint           not null, primary key
#  field_mapping   :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  campaign_id     :bigint           not null
#  distribution_id :bigint           not null
#
# Indexes
#
#  index_campaign_distributions_on_campaign_id      (campaign_id)
#  index_campaign_distributions_on_distribution_id  (distribution_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (distribution_id => distributions.id)
#
require "test_helper"

class CampaignDistributionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
