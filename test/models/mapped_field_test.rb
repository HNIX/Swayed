# == Schema Information
#
# Table name: mapped_fields
#
#  id                       :bigint           not null, primary key
#  is_static                :boolean          default(FALSE)
#  name                     :string
#  static_value             :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  campaign_distribution_id :bigint           not null
#  campaign_field_id        :bigint
#
# Indexes
#
#  index_mapped_fields_on_campaign_distribution_id  (campaign_distribution_id)
#  index_mapped_fields_on_campaign_field_id         (campaign_field_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_distribution_id => campaign_distributions.id)
#  fk_rails_...  (campaign_field_id => campaign_fields.id)
#
require "test_helper"

class MappedFieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
