# == Schema Information
#
# Table name: campaign_fields
#
#  id               :bigint           not null, primary key
#  data_type        :integer
#  default_value    :string
#  example_value    :string
#  hide             :boolean
#  is_pii           :boolean
#  max_value        :decimal(, )
#  min_value        :decimal(, )
#  name             :string
#  position         :integer
#  post_only        :boolean          default(FALSE)
#  required         :boolean          default(FALSE)
#  value_acceptance :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  campaign_id      :bigint           not null
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
  include ActionText::Attachable

  # Constants
  VALID_NAME_REGEX = /\A[a-z0-9_]+\z/i
  DATA_TYPE_OPTIONS = {text: 0, number: 1, boolean: 2, date: 3, email: 5, phone: 6}
  VALUE_ACCEPTANCE_OPTIONS = {any: 0, list: 1, range: 2}

  # Enums
  enum data_type: DATA_TYPE_OPTIONS
  enum value_acceptance: VALUE_ACCEPTANCE_OPTIONS

  # Associations
  belongs_to :campaign
  has_rich_text :notes
  acts_as_list scope: :campaign
  has_many :mapped_fields, dependent: :destroy
  has_many :validations, dependent: :destroy
  has_many :list_values, dependent: :destroy
  has_many :source_filters, dependent: :destroy
  has_many :distribution_filters, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :list_values, allow_destroy: true, :reject_if => :all_blank

  # Callbacks for broadcasting changes
  after_create_commit { broadcast_prepend_later_to :campaign_fields, partial: "campaign_fields/index", locals: {campaign_field: self} }
  after_update_commit { broadcast_replace_later_to self }
  after_destroy_commit { broadcast_remove_to :campaign_fields, target: dom_id(self, :index) }

  # Validations
  validates :name, presence: true, format: {with: VALID_NAME_REGEX, message: "can only be alphanumeric with underscores"}, length: {minimum: 2, maximum: 100},
    uniqueness: {scope: :campaign_id, case_sensitive: false, message: "This field name is already used for this campaign."}
  validates :data_type, presence: true, inclusion: {in: DATA_TYPE_OPTIONS.keys.map(&:to_s), message: "%{value} is not a valid field type"}
  validates :value_acceptance, presence: true, inclusion: {in: VALUE_ACCEPTANCE_OPTIONS.keys.map(&:to_s), message: "%{value} is not valid"}
  validate :validate_post_required, :validate_list_values_if_number

  # Instance methods for formatting and validation
  def format_value
    case data_type
    when "text" then "Text"
    when "number" then "Number (whole or decimal)"
    when "boolean" then "Boolean (true or false)"
    when "date" then "ISO 8601 Date (YYYY-MM-DD)"
    when "email" then "Standard email format"
    when "phone" then "Phone number (E.164 format)"
    else "Unknown format"
    end
  end

  def generate_example_value
    case data_type
    when "text" then '"Sample Text"'
    when "number" then "42 or 42.5"
    when "boolean" then "true/false"
    when "date" then "2023-01-01"
    when "email" then "example@email.com"
    when "phone" then "+1234567890"
    else "N/A"
    end
  end

  def enhanced_notes
    prepend_text = case value_acceptance
    when "list"
      format_list_values_as_bullets
    when "range"
      "#{min_value} to #{max_value}"
    else
      ""
    end

    prepend_text.to_s.html_safe
  end

  def operator_options
    case data_type
    when "number"
      {
        "equal" => "Equals",
        "not_equal" => "Does not equal",
        "greater_than" => "Greater than",
        "less_than" => "Less than",
        "greater_than_or_equal" => "Greater than or equal to",
        "less_than_or_equal" => "Less than or equal to"
      }
    when "text"
      {
        "equal" => "Equals",
        "not_equal" => "Does not equal",
        "contains" => "Contains",
        "not_contains" => "Does not contain",
        "starts_with" => "Starts with",
        "ends_with" => "Ends with"
      }
    else {
      "equal" => "Equals",
      "not_equal" => "Does not equal",
      "contains" => "Contains",
      "not_contains" => "Does not contain",
      "starts_with" => "Starts with",
      "ends_with" => "Ends with"
    }
    end
  end

  private

  # Private validation methods
  def validate_post_required
    errors.add(:post_required, "must be true if field contains PII") if !required && is_pii
  end

  def validate_list_values_if_number
    return unless number? && list?
    unless list_values.all? { |value| valid_number?(value.list_value) }
      errors.add(:list_values, "contains invalid number.")
    end
  end

  def valid_number?(value)
    !!Float(value)
  rescue
    false
  end

  def format_list_values_as_bullets
    return "" if list_values.blank?

    list_items = list_values.map { |value| "<li>#{value.list_value}</li>" }.join
    "<ul>#{list_items}</ul>"
  end

  def field_requirements
    case data_type.downcase
    when "text"
      text_requirements
    when "number"
      number_requirements
    when "boolean"
      "Boolean value (true or false)"
    when "date"
      "Valid date in ISO 8601 format (YYYY-MM-DD)"
    when "email"
      "Valid formatted email address"
    when "phone"
      "Valid phone number"
    else
      "Specific requirements are not defined for this type"
    end
  end

  def text_requirements
    (value_acceptance == "list") ? "Any text from the permitted values" : "Any text"
  end

  def number_requirements
    case value_acceptance
    when "list"
      "Any number from the permitted values"
    when "range"
      "Number within the permitted range"
    else
      "Whole or decimal number"
    end
  end

  def phone_number_requirements
    phone_format ? "Phone number in the format: #{phone_format}" : "10-digit phone number"
  end
end
