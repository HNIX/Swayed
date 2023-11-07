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
#  notes             :text
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

  has_many :sources
  has_many :campaigns, through: :sources
  has_many :distributions
  
  CYCLE = %w[monthly weekly daily quarterly]
  CURRENCY = %w[US CAD EUR GBP AUD JPY CHF]


  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :companies, partial: "companies/index", locals: {company: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :companies, target: dom_id(self, :index) }

  scope :sorted, -> { order("created_at DESC") }

  accepts_nested_attributes_for :contacts

  validates :name, presence: true
  validates_uniqueness_to_tenant :name

  # Format Validations
  validates :name, format: { with: /\A[a-zA-Z0-9_\- ]+\z/, message: "can only be alphanumeric with spaces, underscores, and hyphens" }

  # Length Validations
  validates :name, length: { minimum: 2, maximum: 100 }

  def initials
    name.split.map { |word| word[0] }.join
  end

  # def monthly_api_pings_count(month: Time.zone.now.month, year: Time.zone.now.year)
  #   api_pings.where(created_at: Date.new(year, month).beginning_of_month..Date.new(year, month).end_of_month).count
  # end 
end
