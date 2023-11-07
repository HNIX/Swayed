# == Schema Information
#
# Table name: sources
#
#  id                     :bigint           not null, primary key
#  budget                 :integer
#  description            :text
#  failure_redirect_url   :string
#  integration_type       :integer
#  landing_page_url       :string
#  margin                 :decimal(, )
#  minimum_acceptable_bid :decimal(, )
#  name                   :string
#  offer_type             :integer
#  payout                 :integer
#  payout_method          :integer
#  payout_structure       :integer
#  postback_url           :string
#  privacy_policy_url     :string
#  shared                 :boolean
#  status                 :integer          default("active")
#  success_redirect_url   :string
#  terms                  :string
#  timeout                :integer
#  tracking_url           :string
#  traffic_sources        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  campaign_id            :bigint           not null
#  company_id             :bigint           not null
#  unique_source_id       :string
#
# Indexes
#
#  index_sources_on_campaign_id  (campaign_id)
#  index_sources_on_company_id   (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (company_id => companies.id)
#

#
# Indexes
#
#  index_sources_on_campaign_id  (campaign_id)
#  index_sources_on_company_id   (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (company_id => companies.id)
#

require 'securerandom'

class Source < ApplicationRecord

  belongs_to :company
  belongs_to :campaign
  has_many :api_requests
  has_many :leads, through: :api_requests
  has_many :source_tokens, dependent: :destroy

  before_create :generate_source_id
  after_create :generate_source_token

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :sources, partial: "sources/index", locals: {source: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :sources, target: dom_id(self, :index) }

  enum status: { active: 0, paused: 1 }
  enum offer_type: { exclusive: 0, shared: 1 }
  enum payout_method: { percentage: 0, fixed_price: 1 }
  enum term: { due_on_receipt: 0, net_7: 1, net_14: 2, net_15: 3, net_30: 4, net_60: 5 }
  enum integration_type: { affiliate: 0, web_form: 1 }
  enum payout_structure: { pay_per_lead: 0, pay_per_action: 1, pay_per_click: 2 }

  validates :integration_type, :name, presence: true
  validates :company_id, :payout_method, :payout_structure, :offer_type, presence: true, if: -> { integration_type == 'affiliate' }
  validates :margin, presence: true, if: -> { payout_method == 'percentage' }
  validates :payout, presence: true, if: -> { payout_method == 'fixed_price' }
  #validates :landing_page_url, :postback_url, presence: true, if: -> { integration_type == 'web_form' }
  #validates :margin, :minimum_acceptable_bid, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  #validates :payout, numericality: { greater_than: 0 }

  def display_name    
    "#{company&.name}  -  #{name}"
  end

  # Calculate the maximum bid amount based on the source type and payout
  def calculate_max_bid
    case type
      when 'CPL'
        payout
      when 'RevShare'
        # Implement logic to calculate based on revenue sharing
      else
        # Default value or logic for other types
        0
    end
  end

  private

  def generate_source_token
    source_tokens.create!(name: "Token-#{Time.now.to_i}") # This will automatically associate the new token with the source
  end

  def generate_source_id
    loop do
      self.unique_source_id = SecureRandom.urlsafe_base64(6) # generates a 6-character string
      break unless Source.exists?(unique_source_id: unique_source_id)
    end
  end
end
