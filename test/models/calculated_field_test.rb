# == Schema Information
#
# Table name: calculated_fields
#
#  id            :bigint           not null, primary key
#  clean_formula :string
#  error_log     :jsonb
#  formula       :string
#  name          :string
#  status        :integer          default("active")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  campaign_id   :bigint           not null
#
# Indexes
#
#  index_calculated_fields_on_campaign_id  (campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#
require "test_helper"

class CalculatedFieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
