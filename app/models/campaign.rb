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

  belongs_to :vertical
  has_many :campaign_fields, -> { order(position: :asc) }, dependent: :destroy
  has_many :sources
  has_many :leads, through: :sources
  has_many :campaign_distributions
  has_many :distributions, through: :campaign_distributions
  has_many :api_requests

  accepts_nested_attributes_for :campaign_fields, allow_destroy: true, :reject_if => :all_blank
  accepts_nested_attributes_for :sources, :reject_if => :all_blank
  accepts_nested_attributes_for :distributions, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? && attributes['headers_attributes'][0].nil? }
  accepts_nested_attributes_for :campaign_distributions
  
  after_create_commit :sync_campaign_fields
  before_create :set_unique_name

  enum status: { draft: 0, active: 1, paused: 2, test: 3, ended: 4 }
  enum campaign_type: { ping_post: 0, direct_post: 1, calls: 2 }
  enum distribution_method: { weighted: 0, round_robin: 1, manual: 2, priority: 3, highest_bid: 4 }
  enum days: {monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6}

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :campaigns, partial: "campaigns/index", locals: {campaign: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :campaigns, target: dom_id(self, :index) }

  scope :sorted, -> { order("created_at DESC") }

  # Presence Validations
  validates :name, presence: true, on: :update
  validates :status, presence: true
  validates :campaign_type, presence: true
  validates :distribution_method, presence: true
  validates :vertical, presence: true

  # Custom Validations
  # validate :active_campaigns_limit
  validate :end_date_after_start_date

  validates_uniqueness_to_tenant :name, message: "This campaign name is already taken.", on: :update

  # Inclusion Validations
  validates :status, inclusion: { in: statuses.keys, message: "%{value} is not a valid status" }
  validates :campaign_type, inclusion: { in: campaign_types.keys, message: "%{value} is not a valid campaign type" }
  validates :distribution_method, inclusion: { in: distribution_methods.keys, message: "%{value} is not a valid distribution method" }

  # Length Validations
  validates :name, length: { minimum: 3, maximum: 100 }, on: :update
  
  # Assuming there's a description field
  validates :description, length: { maximum: 500 }, allow_blank: true

  def generate_base_name
    [campaign_type.titleize, vertical.secondary_category.titleize, distribution_method.titleize].join(' - ')
  end

  def generate_unique_name
    base_name = generate_base_name
    "#{base_name} #{Time.now.to_i}"
  end

  def set_unique_name
    self.name = generate_unique_name
  end
    
  # Custom method to ensure the end date is after the start date
  def end_date_after_start_date
    return if distribution_schedule_end_time.blank? || distribution_schedule_start_time.blank?

    if distribution_schedule_end_time < distribution_schedule_start_time
      errors.add(:distribution_schedule_end_time, "must be after the start date")
    end
  end

  # Custom method to check the active campaigns limit
  # Just a placeholder; the actual implementation depends on your business rules
  def active_campaigns_limit
    # replace 10 with whatever limit you want
    if self.active? && Campaign.where(state: 'active').count >= 10
      errors.add(:base, "You have reached the limit for active campaigns.")
    end
  end

  # Implement API ping limits for campaigns 

  # def api_ping_limit_reached?
  #   pings_count >= api_ping_limit
  # end

  # def increment_pings_count
  #   increment!(:pings_count)
  # end

  def available_distributions
    Distribution.all - self.distributions
  end

  ## Move these methods to the draper gem

  def lead_acceptance_rate
    total_leads = leads.count
    accepted_leads = leads.where(status: 'accepted').count

    return 0 if total_leads.zero?

    (accepted_leads.to_f / total_leads) * 100
  end

  def total_revenue
    leads.sum(:revenue_cents) / 100.0
  end

  def total_profit
    leads.sum(:profit_cents) / 100.0
  end

  def leads_in_last_n_days(n)
    leads.where(created_at: (n.days.ago.beginning_of_day)..Time.zone.now)
  end

  def total_leads_last_n_days(n)
    leads_in_last_n_days(n).count
  end

  def acceptance_rate_last_n_days(n)
    accepted_leads = leads.where(status: 'accepted', created_at: (n.days.ago.beginning_of_day)..Time.zone.now)
    total_leads = leads_in_last_n_days(n)
    
    if total_leads.count > 0
      accepted_leads.count.to_f / total_leads.count * 100
    else 
      0
    end
  end

  def total_revenue_last_n_days(n)
    leads_in_last_n_days(n).sum(:revenue_cents) / 100.0
  end

  def total_profit_last_n_days(n)
    leads_in_last_n_days(n).sum(:profit_cents) / 100.0
  end



  private

  #move to a service?

  def sync_campaign_fields
    base_vertical = Vertical.first

    base_vertical.fields.each do |field|
      sync_field(field)
    end

    vertical.fields.each do |field|
      sync_field(field)
    end
  end

  def sync_field(field)
    campaign_field = campaign_fields.find_or_initialize_by(name: field.name)
    campaign_field.update(
      name: field.name,
      data_type: field.data_type,
      post_required: field&.post_required
    )
  end

end
