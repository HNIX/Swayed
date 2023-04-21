# == Schema Information
#
# Table name: companies
#
#  id                :bigint           not null, primary key
#  address           :string
#  billing_cycle     :string
#  city              :string
#  currency          :string
#  name              :string
#  payment_terms     :string
#  payment_threshold :integer
#  state             :string
#  status            :string
#  zip_code          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint
#  tax_id            :string
#
# Indexes
#
#  index_companies_on_account_id  (account_id)
#
require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
