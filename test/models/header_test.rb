# == Schema Information
#
# Table name: headers
#
#  id              :bigint           not null, primary key
#  header_value    :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  distribution_id :bigint
#
# Indexes
#
#  index_headers_on_distribution_id  (distribution_id)
#
# Foreign Keys
#
#  fk_rails_...  (distribution_id => distributions.id)
#
require "test_helper"

class HeaderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
