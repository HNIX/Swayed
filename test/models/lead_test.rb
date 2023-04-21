# == Schema Information
#
# Table name: leads
#
#  id            :bigint           not null, primary key
#  custom_fields :jsonb            not null
#  email         :string
#  first_name    :string
#  last_name     :string
#  phone         :string
#  score         :integer
#  status        :integer          default("current")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :integer
#  api_ping_id   :bigint
#
# Indexes
#
#  index_leads_on_api_ping_id  (api_ping_id)
#
require "test_helper"

class LeadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
