# == Schema Information
#
# Table name: fields
#
#  id               :bigint           not null, primary key
#  data_type        :string
#  default_value    :string
#  example_value    :string
#  hide             :boolean          default(FALSE)
#  is_pii           :boolean
#  max_value        :integer
#  min_value        :integer
#  name             :string
#  position         :integer
#  post_only        :boolean          default(FALSE)
#  required         :boolean          default(FALSE)
#  validated        :boolean          default(FALSE)
#  value_acceptance :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  vertical_id      :bigint           not null
#
# Indexes
#
#  index_fields_on_name_and_vertical_id  (name,vertical_id) UNIQUE
#  index_fields_on_vertical_id           (vertical_id)
#
# Foreign Keys
#
#  fk_rails_...  (vertical_id => verticals.id)
#
require "test_helper"

class FieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end