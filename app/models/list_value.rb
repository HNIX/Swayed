# == Schema Information
#
# Table name: list_values
#
#  id                :bigint           not null, primary key
#  list_value        :string
#  value_type        :integer          default("string")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  campaign_field_id :bigint           not null
#
# Indexes
#
#  index_list_values_on_campaign_field_id  (campaign_field_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_field_id => campaign_fields.id)
#
class ListValue < ApplicationRecord
  belongs_to :campaign_field
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :list_values, partial: "list_values/index", locals: {list_value: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :list_values, target: dom_id(self, :index) }

  enum value_type: {string: 0, number: 1}
end
