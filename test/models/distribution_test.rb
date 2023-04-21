# == Schema Information
#
# Table name: distributions
#
#  id               :bigint           not null, primary key
#  endpoint         :string
#  key              :string
#  response_format  :string
#  response_mapping :jsonb
#  status           :integer
#  template         :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint           not null
#  company_id       :bigint           not null
#
# Indexes
#
#  index_distributions_on_account_id  (account_id)
#  index_distributions_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (company_id => companies.id)
#
require "test_helper"

class DistributionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
