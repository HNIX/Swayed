# == Schema Information
#
# Table name: api_requests
#
#  id              :uuid             not null, primary key
#  accepted        :boolean
#  api_key         :string
#  direction       :integer          default("inbound")
#  endpoint        :string
#  errors          :text
#  headers         :jsonb
#  lead_posted     :boolean
#  method_type     :string
#  price           :integer
#  request_body    :jsonb
#  request_time    :datetime
#  response_body   :jsonb
#  response_code   :integer
#  source_ip       :string
#  status          :integer
#  test            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  campaign_id     :bigint           not null
#  distribution_id :bigint
#  source_id       :bigint
#
# Indexes
#
#  index_api_requests_on_campaign_id      (campaign_id)
#  index_api_requests_on_distribution_id  (distribution_id)
#  index_api_requests_on_source_id        (source_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (distribution_id => distributions.id)
#  fk_rails_...  (source_id => sources.id)
#
class ApiRequest < ApplicationRecord
  self.primary_key = 'id' 
   
  belongs_to :campaign
  belongs_to :source, optional: true
  belongs_to :distribution, optional: true
  
  has_many :api_request_leads
  has_many :leads, through: :api_request_leads

  validates :direction, presence: true
  validate :source_presence_for_inbound
  validate :distribution_presence_for_outbound

  enum status: { pending: 0, accepted: 1, rejected: 2 }
  enum direction: { inbound: 0, outbound: 1 }

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :api_requests, partial: "api_requests/index", locals: {api_request: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :api_requests, target: dom_id(self, :index) }

  def self.duplicate?(request, params, time_frame: 10.minutes)
    # Check for duplicate Jornaya or Trusted Form IDs
    if params[:jornaya_id].present? || params[:trusted_form_id].present?
      duplicate_ping = where(jornaya_id: params[:jornaya_id], trusted_form_id: params[:trusted_form_id]).first
      return true if duplicate_ping.present?
    end

    # Check for exact same ping request body within the given time frame
    time_range = (Time.now - time_frame)..Time.now
    duplicate_ping = where(created_at: time_range).find { |ping| ping.request_body == request }
    duplicate_ping.present?
  end

  def source_presence_for_inbound
    if direction == 'inbound' && source.nil?
      errors.add(:source, "must be present for inbound requests")
    end
  end

  def distribution_presence_for_outbound
    if direction == 'outbound' && distribution.nil?
      errors.add(:distribution, "must be present for outbound requests")
    end
  end
end
