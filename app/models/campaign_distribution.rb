# == Schema Information
#
# Table name: campaign_distributions
#
#  id              :bigint           not null, primary key
#  daily_limit     :integer
#  field_mapping   :jsonb
#  monthly_limit   :integer
#  weekly_limit    :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  campaign_id     :bigint           not null
#  distribution_id :bigint           not null
#
# Indexes
#
#  index_campaign_distributions_on_campaign_id      (campaign_id)
#  index_campaign_distributions_on_distribution_id  (distribution_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (distribution_id => distributions.id)
#
class CampaignDistribution < ApplicationRecord
  after_initialize :set_default_field_mapping

  belongs_to :campaign
  belongs_to :distribution

  has_many :outbound_pings
  has_many :leads, through: :outbound_pings

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :campaign_distributions, partial: "campaign_distributions/index", locals: {campaign_distribution: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :campaign_distributions, target: dom_id(self, :index) }

  private

  def set_default_field_mapping
    self.field_mapping ||= {}
  end

  def over_outbound_ping_limit?(campaign_distribution)
    daily_limit = campaign_distribution.daily_limit
    weekly_limit = campaign_distribution.weekly_limit
    monthly_limit = campaign_distribution.monthly_limit

    daily_pings_count = outbound_pings.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
    weekly_pings_count = outbound_pings.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).count
    monthly_pings_count = outbound_pings.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month).count

    daily_limit_exceeded = daily_limit.present? && daily_pings_count >= daily_limit
    weekly_limit_exceeded = weekly_limit.present? && weekly_pings_count >= weekly_limit
    monthly_limit_exceeded = monthly_limit.present? && monthly_pings_count >= monthly_limit

    daily_limit_exceeded || weekly_limit_exceeded || monthly_limit_exceeded
  end

end
