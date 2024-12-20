# == Schema Information
#
# Table name: validations
#
#  id                :bigint           not null, primary key
#  max_value         :integer
#  min_value         :integer
#  operator          :string
#  validation_type   :integer
#  value_boolean     :boolean
#  value_date        :date
#  value_date_end    :date
#  value_date_start  :date
#  value_integer     :integer
#  value_text        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  campaign_field_id :bigint           not null
#
# Indexes
#
#  index_validations_on_campaign_field_id  (campaign_field_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_field_id => campaign_fields.id)
#
require "test_helper"

class ValidationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
