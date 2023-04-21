# == Schema Information
#
# Table name: sources
#
#  id                 :bigint           not null, primary key
#  budget             :integer
#  landing_page_url   :string
#  name               :string
#  payout             :integer
#  payout_cap         :integer
#  payout_method      :string
#  payout_type        :string
#  ping_cap           :integer
#  postback_url       :string
#  privacy_policy_url :string
#  status             :integer
#  terms              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :bigint           not null
#
# Indexes
#
#  index_sources_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
require "test_helper"

class SourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
