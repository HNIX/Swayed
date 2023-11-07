# == Schema Information
#
# Table name: campaign_fields
#
#  id            :bigint           not null, primary key
#  data_type     :integer
#  example_value :string
#  hide          :boolean
#  is_pii        :boolean
#  label         :string
#  name          :string
#  ping_required :boolean
#  position      :integer
#  post_only     :boolean          default(FALSE)
#  post_required :boolean
#  validated     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  campaign_id   :bigint           not null
#
# Indexes
#
#  index_campaign_fields_on_campaign_id  (campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#
class CampaignField < ApplicationRecord
  include Rules::HasRules
  acts_as_list scope: :campaign

  has_rule_attributes({
    data_type: {
      name: "Data Type",
      type: :string
    }
  })

  belongs_to :campaign
  has_many :mapped_fields
  has_many :validations
  
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :campaign_fields, partial: "campaign_fields/index", locals: {campaign_field: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :campaign_fields, target: dom_id(self, :index) }

  enum data_type: { text: 0, number: 1, boolean: 2, date: 3, list: 4, email: 5, phone: 6, postal_code: 7, ip_address: 8, url: 9  }

  VALID_NAME_REGEX = /\A[a-z0-9_]+\z/i
  validates :name, presence: true
  validates :name, format: { with: VALID_NAME_REGEX, message: "can only be alphanumeric with underscores" }
  validates :data_type, presence: true

  validates :name, uniqueness: { scope: :campaign_id, case_sensitive: false, message: "This field name is already used for this campaign." }
  validates :data_type, inclusion: { in: data_types.keys, message: "%{value} is not a valid field type" }

  validates :name, length: { minimum: 2, maximum: 100 }

  validate :validate_post_required

  private

  def validate_post_required
    if !post_required && is_pii
      errors.add(:post_required, "must be true if field contains PII")
    end
  end
end
