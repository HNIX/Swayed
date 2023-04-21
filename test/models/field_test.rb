# == Schema Information
#
# Table name: fields
#
#  id            :bigint           not null, primary key
#  data_type     :string
#  hide          :boolean          default(FALSE)
#  label         :string
#  name          :string
#  ping_required :boolean          default(FALSE)
#  post_required :boolean          default(FALSE)
#  validated     :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  vertical_id   :bigint           not null
#
# Indexes
#
#  index_fields_on_account_id             (account_id)
#  index_fields_on_label_and_vertical_id  (label,vertical_id) UNIQUE
#  index_fields_on_name_and_vertical_id   (name,vertical_id) UNIQUE
#  index_fields_on_vertical_id            (vertical_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (vertical_id => verticals.id)
#
require "test_helper"

class FieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
