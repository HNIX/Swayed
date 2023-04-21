# == Schema Information
#
# Table name: campaign_fields
#
#  id            :bigint           not null, primary key
#  data_type     :string
#  hide          :boolean
#  label         :string
#  name          :string
#  ping_required :boolean
#  post_required :boolean
#  validated     :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  campaign_id   :bigint           not null
#
# Indexes
#
#  index_campaign_fields_on_account_id   (account_id)
#  index_campaign_fields_on_campaign_id  (campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (campaign_id => campaigns.id)
#
class CampaignField < ApplicationRecord
  acts_as_tenant :account

  belongs_to :campaign
  
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :campaign_fields, partial: "campaign_fields/index", locals: {campaign_field: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :campaign_fields, target: dom_id(self, :index) }

  validates :name, presence: true, uniqueness: { scope: :campaign_id }
  validates :label, presence: true, uniqueness: { scope: :campaign_id }
end
