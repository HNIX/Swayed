# == Schema Information
#
# Table name: list_values
#
#  id                :bigint           not null, primary key
#  list_value        :string
#  value_type        :integer          default("string")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  campaign_field_id :bigint           not null
#
# Indexes
#
#  index_list_values_on_campaign_field_id  (campaign_field_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_field_id => campaign_fields.id)
#
require "test_helper"

class ListValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
