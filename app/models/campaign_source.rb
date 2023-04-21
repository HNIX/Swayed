# == Schema Information
#
# Table name: campaign_sources
#
#  id            :bigint           not null, primary key
#  daily_limit   :integer
#  monthly_limit :integer
#  weekly_limit  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  campaign_id   :bigint           not null
#  source_id     :bigint           not null
#
# Indexes
#
#  index_campaign_sources_on_campaign_id  (campaign_id)
#  index_campaign_sources_on_source_id    (source_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (source_id => sources.id)
#
class CampaignSource < ApplicationRecord
  belongs_to :campaign
  belongs_to :source
  has_many :api_pings
  has_many :leads, through: :api_pings
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :campaign_sources, partial: "campaign_sources/index", locals: {campaign_source: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :campaign_sources, target: dom_id(self, :index) }

  def over_api_ping_limit?(campaign_source)
    daily_limit = campaign_source.daily_limit
    weekly_limit = campaign_source.weekly_limit
    monthly_limit = campaign_source.monthly_limit

    daily_pings_count = api_pings.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
    weekly_pings_count = api_pings.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week).count
    monthly_pings_count = api_pings.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month).count

    daily_limit_exceeded = daily_limit.present? && daily_pings_count >= daily_limit
    weekly_limit_exceeded = weekly_limit.present? && weekly_pings_count >= weekly_limit
    monthly_limit_exceeded = monthly_limit.present? && monthly_pings_count >= monthly_limit

    daily_limit_exceeded || weekly_limit_exceeded || monthly_limit_exceeded
  end

  def filters_invalid?(api_ping_values)
    filters.each do |key, value|
      if api_ping_values[key].blank? || api_ping_values[key] != value
        return true
      end
    end

    false
  end
end
