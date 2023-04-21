# == Schema Information
#
# Table name: campaigns
#
#  id            :bigint           not null, primary key
#  campaign_type :integer          default("leads")
#  description   :text
#  name          :string
#  status        :integer          default("draft")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  vertical_id   :bigint           not null
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
  has_many :campaign_fields, dependent: :destroy

  has_many :campaign_sources
  has_many :sources, through: :campaign_sources
  has_many :api_pings, through: :campaign_sources
  has_many :leads, through: :api_pings

  has_many :campaign_distributions
  has_many :distributions, through: :campaign_distributions
  has_many :outbound_pings, through: :campaign_distributions


  accepts_nested_attributes_for :campaign_fields
  accepts_nested_attributes_for :campaign_sources
  accepts_nested_attributes_for :campaign_distributions
  after_create :sync_campaign_fields

  
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :campaigns, partial: "campaigns/index", locals: {campaign: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :campaigns, target: dom_id(self, :index) }

  scope :sorted, -> { order("created_at DESC") }

  enum status: { draft: 0, active: 1, paused: 2, completed: 3 }
  enum campaign_type: { leads: 0, traffic: 1, calls: 2 }

  validates :name, presence: true
  validates_uniqueness_to_tenant :name

  def api_ping_limit_reached?
    pings_count >= api_ping_limit
  end

  def increment_pings_count
    increment!(:pings_count)
  end

  def available_sources
    Source.all - self.sources
  end

  def available_distributions
    Distribution.all - self.distributions
  end

  def sync_campaign_fields
    base_vertical = Vertical.first

    base_vertical.fields.each do |field|
      campaign_field = campaign_fields.find_or_initialize_by(name: field.name)
      campaign_field.update(
        name: field.name,
        label: field.label, 
        data_type: field.data_type,
        ping_required: field.ping_required,
        post_required: field.post_required
        # Add any other attributes you want to copy from the Field to the CampaignField model
      )
    end

    vertical.fields.each do |field|
      campaign_field = campaign_fields.find_or_initialize_by(name: field.name)
      campaign_field.update(
        name: field.name,
        label: field.label, 
        data_type: field.data_type,
        ping_required: field.ping_required,
        post_required: field.post_required
        # Add any other attributes you want to copy from the Field to the CampaignField model
      )
    end
  end
end
