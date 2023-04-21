# == Schema Information
#
# Table name: leads
#
#  id            :bigint           not null, primary key
#  custom_fields :jsonb            not null
#  email         :string
#  first_name    :string
#  last_name     :string
#  phone         :string
#  score         :integer
#  status        :integer          default("current")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :integer
#  api_ping_id   :bigint
#
# Indexes
#
#  index_leads_on_api_ping_id  (api_ping_id)
#
class Lead < ApplicationRecord
  acts_as_tenant :account
  belongs_to :api_ping
  has_many :outbound_pings
  has_many :campaign_distributions, through: :outbound_pings
  has_many :distributions, through: :campaign_distributions
  
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :leads, partial: "leads/index", locals: {lead: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :leads, target: dom_id(self, :index) }

  enum :status, %i(current accepted rejected sold duplicate fraudulent)

  validates :api_ping_id, uniqueness: { message: 'A lead already exists for this ping ID' }
end
