# == Schema Information
#
# Table name: mapped_fields
#
#  id                       :bigint           not null, primary key
#  is_static                :boolean          default(FALSE)
#  name                     :string
#  static_value             :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  campaign_distribution_id :bigint           not null
#  campaign_field_id        :bigint
#
# Indexes
#
#  index_mapped_fields_on_campaign_distribution_id  (campaign_distribution_id)
#  index_mapped_fields_on_campaign_field_id         (campaign_field_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_distribution_id => campaign_distributions.id)
#  fk_rails_...  (campaign_field_id => campaign_fields.id)
#
class MappedField < ApplicationRecord
  before_validation :handle_custom_value
  validate :ensure_static_value_present_for_custom_field

  belongs_to :campaign_field, optional: true
  belongs_to :campaign_distribution
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :mapped_fields, partial: "mapped_fields/index", locals: {mapped_field: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :mapped_fields, target: dom_id(self, :index) }

  validates :name, presence: true, uniqueness: { scope: :campaign_distribution_id }
  #validates :campaign_field_id, presence: true, unless: :is_static?

  def handle_custom_value
    if self.campaign_field_id == -1 
      self.campaign_field_id = nil 
      self.is_static = true
    else
      self.is_static = false
      self.static_value = ""
    end
  end

  def ensure_static_value_present_for_custom_field
    if is_static && static_value.blank?
      errors.add(:static_value, "can't be blank when custom value is selected")
    end
  end

  def custom_value_selected?
    campaign_field_id.nil? && static_value.present?
  end
end
