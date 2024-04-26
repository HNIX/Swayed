# == Schema Information
#
# Table name: campaign_fields
#
#  id               :bigint           not null, primary key
#  data_type        :integer
#  default_value    :string
#  example_value    :string
#  hide             :boolean
#  is_pii           :boolean
#  max_value        :decimal(, )
#  min_value        :decimal(, )
#  name             :string
#  position         :integer
#  post_only        :boolean          default(FALSE)
#  required         :boolean          default(FALSE)
#  value_acceptance :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  campaign_id      :bigint           not null
#
# Indexes
#
#  index_campaign_fields_on_campaign_id  (campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#
require "test_helper"

class CampaignFieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
