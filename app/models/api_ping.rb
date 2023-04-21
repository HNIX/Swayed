# == Schema Information
#
# Table name: api_pings
#
#  id                 :uuid
#  accepted           :boolean
#  action             :text
#  endpoint           :text
#  headers            :jsonb
#  host               :string
#  ip_address         :string
#  lead_posted        :boolean
#  post_params        :jsonb
#  price              :integer
#  request_body       :text
#  request_method     :string
#  response           :jsonb
#  status             :integer          default("pending")
#  test               :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint           not null
#  campaign_source_id :bigint
#
# Indexes
#
#  index_api_pings_on_account_id          (account_id)
#  index_api_pings_on_campaign_source_id  (campaign_source_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class ApiPing < ApplicationRecord
  acts_as_tenant :account

  belongs_to :campaign_source
  has_one :campaign, through: :campaign_source
  has_one :source, through: :campaign_source
  has_one :lead
  
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :api_pings, partial: "api_pings/index", locals: {api_ping: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :api_pings, target: dom_id(self, :index) }

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  #validates :request_body, presence: true

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

  def to_param
    uuid
  end

end
