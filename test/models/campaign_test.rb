# == Schema Information
#
# Table name: campaigns
#
#  id            :bigint           not null, primary key
#  campaign_type :integer          default("leads")
#  description   :text
#  name          :string
#  status        :integer          default("draft")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  vertical_id   :bigint           not null
#
# Indexes
#
#  index_campaigns_on_account_id   (account_id)
#  index_campaigns_on_vertical_id  (vertical_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (vertical_id => verticals.id)
#
require "test_helper"

class CampaignTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
