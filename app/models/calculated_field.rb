# == Schema Information
#
# Table name: calculated_fields
#
#  id            :bigint           not null, primary key
#  clean_formula :string
#  error_log     :jsonb
#  formula       :string
#  name          :string
#  status        :integer          default("active")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  campaign_id   :bigint           not null
#
# Indexes
#
#  index_calculated_fields_on_campaign_id  (campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#
class CalculatedField < ApplicationRecord
  before_save :sanitize_and_clean_formula

  belongs_to :campaign
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :calculated_fields, partial: "calculated_fields/index", locals: {calculated_field: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :calculated_fields, target: dom_id(self, :index) }

  enum status: {active: 0, paused: 1, archived: 2, errors: 3}

  validates :formula, :name, presence: true

  def log_error(error_type, message)
    CalculatedField.transaction do
      update!(status: "errors")

      current_log = error_log || []
      current_log << {error_type: error_type, message: message, timestamp: Time.current}
      update!(error_log: current_log)
    end
  end

  private

  def sanitize_and_clean_formula
    # Strip HTML
    stripped_formula = ActionView::Base.full_sanitizer.sanitize(formula)

    # Clean text
    stripped_formula.gsub("&nbsp;", "").delete("\n").gsub('\"', "'").gsub("&amp;", "&").gsub("&gt;", ">").gsub("&lt;", "<")
  end
end
