# == Schema Information
#
# Table name: outbound_pings
#
#  id                       :bigint           not null, primary key
#  accepted                 :boolean
#  endpoint                 :string
#  headers                  :jsonb
#  host                     :string
#  lead_posted              :boolean
#  request_body             :text
#  request_method           :string
#  response                 :jsonb
#  test                     :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  account_id               :bigint           not null
#  campaign_distribution_id :bigint           not null
#  lead_id                  :bigint           not null
#
# Indexes
#
#  index_outbound_pings_on_account_id                (account_id)
#  index_outbound_pings_on_campaign_distribution_id  (campaign_distribution_id)
#  index_outbound_pings_on_lead_id                   (lead_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (campaign_distribution_id => campaign_distributions.id)
#  fk_rails_...  (lead_id => leads.id)
#
class OutboundPing < ApplicationRecord
  acts_as_tenant :account

  belongs_to :lead
  belongs_to :campaign_distribution

  #validates :request_body, presence: true

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :outbound_pings, partial: "outbound_pings/index", locals: {outbound_ping: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :outbound_pings, target: dom_id(self, :index) }

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
  
end
