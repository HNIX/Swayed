# == Schema Information
#
# Table name: companies
#
#  id                :bigint           not null, primary key
#  address           :string
#  billing_cycle     :string
#  city              :string
#  currency          :string
#  name              :string
#  payment_terms     :string
#  payment_threshold :integer
#  state             :string
#  status            :string
#  zip_code          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :bigint
#  tax_id            :string
#
# Indexes
#
#  index_companies_on_account_id  (account_id)
#
class Company < ApplicationRecord
  acts_as_tenant :account

  has_many :contacts, dependent: :destroy
  has_many :affiliate_tokens, dependent: :destroy

  has_many :sources
  has_many :campaign_sources, through: :sources
  has_many :campaigns, through: :campaign_sources
  has_many :distributions
  has_many :campaign_distributions, through: :distributions
  
  has_many :verticals, through: :campaigns
  has_many :api_pings, through: :campaign_sources
  has_many :outbound_pings, through: :campaign_distributions
  has_many :leads, through: :api_pings

  CYCLE = %w[monthly weekly daily quarterly]
  CURRENCY = %w[US CAD EUR GBP AUD JPY CHF]


  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :companies, partial: "companies/index", locals: {company: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :companies, target: dom_id(self, :index) }

  accepts_nested_attributes_for :contacts
  accepts_nested_attributes_for :sources
  accepts_nested_attributes_for :distributions

  scope :sorted, -> { order("created_at DESC") }

  validates :name, presence: true
  validates_uniqueness_to_tenant :name

  def initials
    name.split.map { |word| word[0] }.join
  end

  # def monthly_api_pings_count(month: Time.zone.now.month, year: Time.zone.now.year)
  #   api_pings.where(created_at: Date.new(year, month).beginning_of_month..Date.new(year, month).end_of_month).count
  # end 
end
