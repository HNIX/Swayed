# == Schema Information
#
# Table name: distributions
#
#  id                        :bigint           not null, primary key
#  conditional_logic_enabled :boolean
#  endpoint                  :string
#  headers                   :boolean
#  headers_option            :boolean
#  key                       :string
#  name                      :string
#  request_body_all_fields   :boolean
#  request_format            :integer
#  request_method            :integer
#  response_format           :string
#  response_mapping          :jsonb
#  select_fields             :boolean
#  status                    :integer          default("draft")
#  template                  :jsonb
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  company_id                :bigint           not null
#
# Indexes
#
#  index_distributions_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Distribution < ApplicationRecord
  after_initialize :set_default_response_mapping

  belongs_to :company

  has_many :campaign_distributions
  has_many :campaigns, through: :campaign_distributions
  has_many :api_requests, as: :requestable
  has_many :leads, through: :api_requests, source: :lead
  has_many :headers, dependent: :destroy
  has_and_belongs_to_many :distribution_filters

  accepts_nested_attributes_for :headers, allow_destroy: true, :reject_if => :all_blank

  enum request_method: {get: 0, post: 1, put: 2, patch: 3}
  enum request_format: {form: 0, json: 1, xml: 2}
  enum status: {draft: 0, active: 1, paused: 2, archived: 3}

  scope :active, -> { where(status: ["active", "paused"]) }
  scope :paused, -> { where(status: "paused") }
  scope :archived, -> { where(status: "archived") }

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :distributions, partial: "distributions/index", locals: {distribution: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :distributions, target: dom_id(self, :index) }

  # Presence Validations
  validates :name, presence: true
  validates :endpoint, presence: true
  validates :request_method, presence: true
  validates :request_format, presence: true

  # Inclusion Validations
  validates :request_method, inclusion: {in: request_methods.keys, message: "%{value} is not a valid request method"}
  validates :request_format, inclusion: {in: request_formats.keys, message: "%{value} is not a valid request format"}

  # Length Validations
  validates :name, length: {minimum: 3, maximum: 100}

  # Uniqueness Validations
  validates :name, uniqueness: {case_sensitive: false, message: "This distribution name is already in use."}

  # Format Validations
  validates :name, format: {with: /\A[a-zA-Z0-9_\- ]+\z/, message: "can only be alphanumeric with spaces, underscores, and hyphens"}
  validates :endpoint, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "is not a valid URL"}

  # Custom Validations
  # For instance, ensuring a buyer's endpoint is reachable (though this might be better done asynchronously in the real world)
  # validate :endpoint_reachable

  def last_api_request_time
    api_requests.last&.created_at
  end

  def total_revenue
    leads.sum(:revenue_cents) / 100
  end

  def total_profit
    leads.sum(:profit_cents) / 100
  end

  private

  def set_default_response_mapping
    self.response_mapping ||= {}
  end

  def endpoint_reachable
    response = Faraday.head(endpoint_url)
    unless response.success?
      errors.add(:endpoint_url, "is not reachable or didn't respond successfully.")
    end
  rescue Faraday::ConnectionFailed
    errors.add(:endpoint_url, "is not reachable.")
  end
end
