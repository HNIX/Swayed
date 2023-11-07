# == Schema Information
#
# Table name: campaign_fields
#
#  id            :bigint           not null, primary key
#  data_type     :integer
#  example_value :string
#  hide          :boolean
#  is_pii        :boolean
#  label         :string
#  name          :string
#  ping_required :boolean
#  position      :integer
#  post_only     :boolean          default(FALSE)
#  post_required :boolean
#  validated     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  campaign_id   :bigint           not null
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
