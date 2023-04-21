# == Schema Information
#
# Table name: distributions
#
#  id               :bigint           not null, primary key
#  endpoint         :string
#  key              :string
#  response_format  :string
#  response_mapping :jsonb
#  status           :integer
#  template         :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint           not null
#  company_id       :bigint           not null
#
# Indexes
#
#  index_distributions_on_account_id  (account_id)
#  index_distributions_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (company_id => companies.id)
#
class Distribution < ApplicationRecord
  acts_as_tenant :account
  after_initialize :set_default_response_mapping

  belongs_to :company
  has_many :campaign_distributions
  has_many :campaigns, through: :campaign_distributions
  has_many :outbound_pings, through: :campaign_distributions
  has_many :leads, through: :outbound_pings

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :distributions, partial: "distributions/index", locals: {distribution: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :distributions, target: dom_id(self, :index) }

  private

  def set_default_response_mapping
    self.response_mapping ||= {}
  end
end
