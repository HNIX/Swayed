# == Schema Information
#
# Table name: distributions
#
#  id                        :bigint           not null, primary key
#  conditional_logic_enabled :boolean
#  endpoint                  :string
#  headers                   :boolean
#  headers_option            :boolean
#  key                       :string
#  name                      :string
#  request_body_all_fields   :boolean
#  request_format            :integer
#  request_method            :integer
#  response_format           :string
#  response_mapping          :jsonb
#  select_fields             :boolean
#  status                    :integer          default("draft")
#  template                  :jsonb
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  company_id                :bigint           not null
#
# Indexes
#
#  index_distributions_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
require "test_helper"

class DistributionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
