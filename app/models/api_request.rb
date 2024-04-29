# == Schema Information
#
# Table name: api_requests
#
#  id                :uuid             not null, primary key
#  accepted          :boolean
#  api_key           :string
#  direction         :integer          default("inbound")
#  endpoint          :string
#  headers           :jsonb
#  lead_posted       :boolean
#  method_type       :string
#  price             :integer
#  request_body      :jsonb
#  request_body_hash :string
#  request_errors    :text
#  request_time      :datetime
#  requestable_type  :string
#  response_body     :jsonb
#  response_code     :integer
#  source_ip         :string
#  status            :integer
#  test              :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  campaign_id       :bigint           not null
#  requestable_id    :bigint
#
# Indexes
#
#  index_api_requests_on_campaign_id        (campaign_id)
#  index_api_requests_on_request_body_hash  (request_body_hash)
#  index_api_requests_on_requestable        (requestable_type,requestable_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#
require "digest"
require "json"
class ApiRequest < ApplicationRecord
  self.primary_key = "id"

  include PgSearch::Model

  pg_search_scope :search_by_terms,
    against: [:id, :direction, :status, :created_at],
    associated_against: {
      source: [:name], # Assuming Source has a name attribute
      distribution: [:name] # Assuming Distribution has a name attribute
    },
    using: {
      tsearch: {prefix: true}
    }

  # Associations
  belongs_to :campaign
  belongs_to :requestable, polymorphic: true

  # Assuming 'direction' attribute determines if the request is inbound or outbound
  has_one :lead, dependent: :destroy # For inbound requests

  # For the many-to-many relationship with leads for outbound requests
  has_many :api_request_leads
  has_many :leads, through: :api_request_leads

  # Validations
  validates :direction, presence: true
  validate :source_or_distribution_presence

  enum status: {pending: 0, accepted: 1, rejected: 2}
  enum direction: {inbound: 0, outbound: 1}

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :api_requests, partial: "api_requests/index", locals: {api_request: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :api_requests, target: dom_id(self, :index) }

  before_save :hash_request_body

  def self.duplicate?(request_body, params, time_frame: 10.minutes)
    request_body_hash = Digest::SHA256.hexdigest(request_body)

    return true if duplicate_by_ids?(params)

    duplicate_by_request_body_hash?(request_body_hash, time_frame)
  end

  def self.duplicate_by_ids?(params)
    if params[:jornaya_id].present? || params[:trusted_form_id].present?
      where(jornaya_id: params[:jornaya_id], trusted_form_id: params[:trusted_form_id])
        .exists?
    end
  end

  def self.duplicate_by_request_body_hash?(request_body_hash, time_frame)
    time_range = Time.now - time_frame..Time.now
    where(created_at: time_range, request_body_hash: request_body_hash).exists?
  end

  private

  def source_or_distribution_presence
    if direction == "inbound" && requestable_type != "Source"
      errors.add(:requestable, "must be associated with a source for inbound requests")
    elsif direction == "outbound" && requestable_type != "Distribution"
      errors.add(:requestable, "must be associated with a distribution for outbound requests")
    end
  end

  def hash_request_body
    if request_body_changed?
      self.request_body_hash = Digest::SHA256.hexdigest(request_body.to_json)
    end
  end
end
