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
#  secure_token           :string
#  shared                 :boolean
#  status                 :integer          default("active")
#  success_redirect_url   :string
#  terms                  :string
#  timeout                :integer          default(15000)
#  tracking_url           :string
#  traffic_sources        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  campaign_id            :bigint           not null
#  company_id             :bigint
#  unique_source_id       :string
#
# Indexes
#
#  index_sources_on_campaign_id   (campaign_id)
#  index_sources_on_company_id    (company_id)
#  index_sources_on_secure_token  (secure_token) UNIQUE
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
  include PgSearch::Model
  pg_search_scope :search, against: :name, using: { tsearch: { prefix: true } }

  belongs_to :company, optional: true
  belongs_to :campaign
  has_many :api_requests, as: :requestable
  has_many :leads, through: :api_requests, source: :lead
  has_one :source_token, dependent: :destroy
  has_and_belongs_to_many :source_filters

  enum status: { active: 0, paused: 1, archived: 2 }
  enum offer_type: { exclusive: 0, shared: 1 }
  enum payout_method: { percentage: 0, fixed_price: 1 }
  enum integration_type: { affiliate: 0, web_form: 1 }
  enum payout_structure: { per_lead: 0, per_action: 1, per_click: 2 }

  before_create :generate_source_id
  after_create :generate_source_token
  before_create :generate_secure_token

  after_create_commit -> { broadcast_prepend_later_to :sources, partial: "sources/index", locals: {source: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :sources, target: dom_id(self, :index) }

  validates :name, :integration_type, presence: true
  validates :company_id, :payout_method, :payout_structure, :offer_type, presence: true, if: -> { affiliate? }
  validates :margin, presence: true, if: -> { percentage? }
  validates :payout, presence: true, if: -> { fixed_price? }
  validate :integration_type_cannot_change, :affiliate_cannot_change, on: :update

  validates :success_redirect_url, :failure_redirect_url, format: { with: URI::regexp(%w[http https]), message: "Invalid URL format" }, allow_blank: true
  validates :budget, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  scope :active, -> { where(status: [:active, :paused]) }
  scope :paused, -> { where(status: :paused) }
  scope :archived, -> { where(status: :archived) }

  def display_name
    "#{company&.name} - #{name}"
  end

  def last_api_request_time
    api_requests.last&.created_at
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

  def total_revenue
    leads.where(status: 'sold').sum(:revenue_cents)/100
  end

  def total_profit
    leads.where(status: 'sold').sum(:profit_cents)/100
  end

  private

  def generate_source_token
    build_source_token(name: "Token-#{Time.now.to_i}").save
  end
  
  def generate_secure_token
    self.secure_token = SecureRandom.hex(10) # generates a random hex string
  end

  def generate_source_id
    self.unique_source_id = SecureRandom.urlsafe_base64(6) until unique_source_id_valid?
  end

  def unique_source_id_valid?
    unique_source_id.present? && !Source.exists?(unique_source_id: unique_source_id)
  end

  def integration_type_cannot_change
    errors.add(:integration_type, "cannot be changed after creation") if integration_type_changed? && persisted?
  end

  def affiliate_cannot_change
    errors.add(:company_id, "Affiliate cannot be changed after creation") if company_id_changed? && persisted?
  end
end

