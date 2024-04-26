# == Schema Information
#
# Table name: source_filters
#
#  id                :bigint           not null, primary key
#  apply_to_all      :boolean          default(FALSE)
#  criteria          :jsonb            not null
#  name              :string
#  operator          :string
#  status            :integer          default("active")
#  value             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  campaign_field_id :bigint           not null
#  campaign_id       :bigint           not null
#
# Indexes
#
#  index_source_filters_on_campaign_field_id  (campaign_field_id)
#  index_source_filters_on_campaign_id        (campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_field_id => campaign_fields.id)
#  fk_rails_...  (campaign_id => campaigns.id)
#
require "test_helper"

class SourceFilterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
