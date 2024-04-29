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
#  index_fields_on_name         (name) UNIQUE
#  index_fields_on_vertical_id  (vertical_id)
#
# Foreign Keys
#
#  fk_rails_...  (vertical_id => verticals.id)
#
class Field < ApplicationRecord
  include ActionText::Attachable

  has_rich_text :notes

  belongs_to :vertical

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :fields, partial: "fields/index", locals: {field: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :fields, target: dom_id(self, :index) }

  enum data_type: {text: 0, number: 1, boolean: 2, date: 3, email: 5, phone: 6}
  enum value_acceptance: {any: 0, list: 1, range: 2}

  validates :name, presence: true, uniqueness: {scope: :vertical_id}
  validates :data_type, presence: true
  validate :validate_data_type

  private

  def validate_data_type
    errors.add(:data_type, "is not valid") unless DATA_TYPES.include?(data_type)
  end
end
