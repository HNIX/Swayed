# == Schema Information
#
# Table name: verticals
#
#  id                 :bigint           not null, primary key
#  archived           :boolean
#  description        :text
#  primary_category   :integer
#  secondary_category :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint           not null
#
# Indexes
#
#  index_verticals_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require "test_helper"

class VerticalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
