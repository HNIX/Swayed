# == Schema Information
#
# Table name: campaigns
#
#  id                               :bigint           not null, primary key
#  campaign_type                    :integer          default("ping_post")
#  description                      :text
#  distribution_method              :integer
#  distribution_schedule_days       :string           default([]), is an Array
#  distribution_schedule_enabled    :boolean
#  distribution_schedule_end_time   :time
#  distribution_schedule_start_time :time
#  name                             :string
#  status                           :integer          default("draft")
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  account_id                       :bigint           not null
#  vertical_id                      :bigint           not null
#
# Indexes
#
#  index_campaigns_on_account_id   (account_id)
#  index_campaigns_on_vertical_id  (vertical_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (vertical_id => verticals.id)
#
class Campaign < ApplicationRecord
  acts_as_tenant :account

  include PgSearch::Model
  pg_search_scope :search, against: [:name, :status], using: {tsearch: {prefix: true}}

  # Constants
  ACTIVE_CAMPAIGNS_LIMIT = 10
  DAYS_OPTIONS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

  # Associations
  belongs_to :vertical
  has_many :campaign_fields, -> { order(position: :asc) }, dependent: :destroy
  has_many :calculated_fields, dependent: :destroy
  has_many :sources, dependent: :destroy
  has_many :source_filters, dependent: :destroy
  has_many :distribution_filters, dependent: :destroy
  has_many :campaign_distributions, dependent: :destroy
  has_many :distributions, through: :campaign_distributions
  has_many :api_requests, dependent: :destroy
  has_many :leads, through: :api_requests, source: :lead

  # Enums
  enum status: {draft: 0, active: 1, paused: 2, test: 3, ended: 4}
  enum campaign_type: {ping_post: 0, direct_post: 1, calls: 2}
  enum distribution_method: {weighted: 0, round_robin: 1, manual: 2, priority: 3, highest_bid: 4}

  # Validations
  validates :name, presence: true, length: {minimum: 3, maximum: 100}, uniqueness: {scope: :account_id, message: "This campaign name is already taken."}, on: :update
  validates :status, :campaign_type, :distribution_method, :vertical, presence: true
  validates :status, inclusion: {in: statuses.keys, message: "%{value} is not a valid status"}

  # Length Validations
  validates :description, length: {maximum: 500}, allow_blank: true

  # Inclusion Validations
  validates :campaign_type, inclusion: {in: campaign_types.keys, message: "%{value} is not a valid campaign type"}
  validates :distribution_method, inclusion: {in: distribution_methods.keys, message: "%{value} is not a valid distribution method"}

  # Custom Validations
  validate :end_date_after_start_date
  # validate :active_campaigns_limit # Uncomment if needed

  # Scopes
  scope :sorted, -> { order("created_at DESC") }

  # Nested Attributes
  accepts_nested_attributes_for :campaign_fields, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :sources, reject_if: :all_blank
  accepts_nested_attributes_for :distributions, allow_destroy: true, reject_if: proc { |attributes| attributes["name"].blank? && attributes["headers_attributes"][0].nil? }
  accepts_nested_attributes_for :campaign_distributions

  # Callbacks
  before_create :set_unique_name
  after_create_commit -> { CampaignSyncService.new(self).sync_fields }
  after_create_commit -> { broadcast_prepend_later_to :campaigns, partial: "campaigns/index", locals: {campaign: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :campaigns, target: dom_id(self, :index) }

  # Instance methods
  def generate_sample_payload
    campaign_fields.each_with_object({}) do |field, payload|
      payload[field.name] = sample_value_for(field, field.data_type)
    end
  end

  # def api_ping_limit_reached?
  #   pings_count.to_i >= api_ping_limit.to_i
  # end

  # def increment_pings_count
  #   increment!(:pings_count)
  # end

  def available_distributions
    Distribution.where.not(id: distributions.select(:id))
  end

  # Custom validation methods
  private

  def set_unique_name
    self.name = UniqueNameGenerator.new(self).generate
  end

  def end_date_after_start_date
    return if distribution_schedule_end_time.blank? || distribution_schedule_start_time.blank?
    errors.add(:distribution_schedule_end_time, "must be after the start date") if distribution_schedule_end_time < distribution_schedule_start_time
  end

  def active_campaigns_limit
    errors.add(:base, "You have reached the limit of #{ACTIVE_CAMPAIGNS_LIMIT} active campaigns.") if active? && Campaign.where(status: "active").limit(ACTIVE_CAMPAIGNS_LIMIT).exists?
  end

  def sample_value_for(field, data_type)
    case data_type.downcase
    when "text"
      field.name
    when "number"
      123
    when "date"
      Date.today.to_s
    when "boolean"
      [true, false].sample
    when "email"
      "email@example.com"
    when "phone"
      "(123) 456-7890"
    else
      "Unknown Type"
    end
  end
end
