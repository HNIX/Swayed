# == Schema Information
#
# Table name: distribution_filters
#
#  id                :bigint           not null, primary key
#  apply_to_all      :boolean
#  criteria          :jsonb
#  name              :string
#  operator          :string
#  status            :integer          default("active")
#  value             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  campaign_field_id :bigint           not null
#  campaign_id       :bigint           not null
#
# Indexes
#
#  index_distribution_filters_on_campaign_field_id  (campaign_field_id)
#  index_distribution_filters_on_campaign_id        (campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_field_id => campaign_fields.id)
#  fk_rails_...  (campaign_id => campaigns.id)
#
class DistributionFilter < ApplicationRecord
  belongs_to :campaign
  belongs_to :campaign_field
  has_and_belongs_to_many :distributions

  enum status: {active: 0, paused: 1, archived: 2}

  def applies_to?(distribution)
    apply_to_all || distributions.include?(distribution)
  end

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :distribution_filters, partial: "distribution_filters/index", locals: {distribution_filter: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :distribution_filters, target: dom_id(self, :index) }
end
