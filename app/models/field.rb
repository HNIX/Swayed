# == Schema Information
#
# Table name: fields
#
#  id            :bigint           not null, primary key
#  data_type     :string
#  example_value :string
#  hide          :boolean          default(FALSE)
#  label         :string
#  name          :string
#  ping_required :boolean          default(FALSE)
#  post_required :boolean          default(FALSE)
#  validated     :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  vertical_id   :bigint           not null
#
# Indexes
#
#  index_fields_on_label_and_vertical_id  (label,vertical_id) UNIQUE
#  index_fields_on_name_and_vertical_id   (name,vertical_id) UNIQUE
#  index_fields_on_vertical_id            (vertical_id)
#
# Foreign Keys
#
#  fk_rails_...  (vertical_id => verticals.id)
#
class Field < ApplicationRecord
  belongs_to :vertical
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :fields, partial: "fields/index", locals: {field: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :fields, target: dom_id(self, :index) }

  DATA_TYPES = %w[text date number email zip_code ip_address phone_number url].freeze

  validates :name, presence: true, uniqueness: { scope: :vertical_id }
  validates :data_type, presence: true
  validate :validate_data_type

  private

  def validate_data_type
    errors.add(:data_type, "is not valid") unless DATA_TYPES.include?(data_type)
  end
end
