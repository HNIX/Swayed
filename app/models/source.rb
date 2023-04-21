# == Schema Information
#
# Table name: sources
#
#  id                 :bigint           not null, primary key
#  budget             :integer
#  landing_page_url   :string
#  name               :string
#  payout             :integer
#  payout_cap         :integer
#  payout_method      :string
#  payout_type        :string
#  ping_cap           :integer
#  postback_url       :string
#  privacy_policy_url :string
#  status             :integer
#  terms              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :bigint           not null
#
# Indexes
#
#  index_sources_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Source < ApplicationRecord

  belongs_to :company
  has_many :campaign_sources
  has_many :campaigns, through: :campaign_sources
  has_many :api_pings, through: :campaign_sources
  has_many :leads, through: :api_pings

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :sources, partial: "sources/index", locals: {source: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :sources, target: dom_id(self, :index) }
end
