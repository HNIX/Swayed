# == Schema Information
#
# Table name: campaign_fields
#
#  id            :bigint           not null, primary key
#  data_type     :string
#  hide          :boolean
#  label         :string
#  name          :string
#  ping_required :boolean
#  post_required :boolean
#  validated     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  campaign_id   :bigint           not null
#
# Indexes
#
#  index_campaign_fields_on_account_id   (account_id)
#  index_campaign_fields_on_campaign_id  (campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (campaign_id => campaigns.id)
#
require "test_helper"

class CampaignFieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
