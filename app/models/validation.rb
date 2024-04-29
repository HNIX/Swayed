# == Schema Information
#
# Table name: validations
#
#  id                :bigint           not null, primary key
#  max_value         :integer
#  min_value         :integer
#  operator          :string
#  validation_type   :integer
#  value_boolean     :boolean
#  value_date        :date
#  value_date_end    :date
#  value_date_start  :date
#  value_integer     :integer
#  value_text        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  campaign_field_id :bigint           not null
#
# Indexes
#
#  index_validations_on_campaign_field_id  (campaign_field_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_field_id => campaign_fields.id)
#
class Validation < ApplicationRecord
  belongs_to :campaign_field

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :validations, partial: "validations/index", locals: {validation: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :validations, target: dom_id(self, :index) }

  enum validation_type: {presence: 0, format: 1, value_length: 2, date: 3, number_value: 4, text_value: 5}
  enum operator: {greater_than: 0, less_than: 1, between: 2, equals: 3, inclusion: 6, exclusion: 7}

  validates :validation_type, presence: true, inclusion: {in: validation_types.keys, message: "is not a valid type"}
  validates :operator, presence: true, if: :operator_validation?

  validates :value_text, presence: true, if: :text_value?
  validates :value_integer, presence: true, if: -> { number_value? && !between? }
  validates :value_boolean, presence: true, if: -> { presence? }
  validates :min_value, presence: true, if: -> { number_value? && between? }
  validates :max_value, presence: true, if: -> { number_value? && between? }
  validates :value_date, presence: true, if: -> { date? && !between? }
  validates :value_date_start, presence: true, if: -> { date? && between? }
  validates :value_date_end, presence: true, if: -> { date? && between? }

  def display_name
    case validation_type
    when "presence"
      "Presence Validation"
    when "format"
      "Format Validation"
    when "value_length"
      "Value Length Validation"
    when "regex"
      "Regular Expression Validation"
    when "date"
      "Date Validation"
    when "number_value"
      "Number Value Validation"
    when "text_value"
      "Text Value Validation"
    when "inclusion"
      "Inclusion Validation"
    when "exclusion"
      "Exclusion Validation"
    else
      "Unknown Validation"
    end
  end

  def operator_validation?
    validation_type == "value_length" || validation_type == "date" || validation_type == "number_value" || validation_type.nil?
  end
end
