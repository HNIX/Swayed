# == Schema Information
#
# Table name: leads
#
#  id             :bigint           not null, primary key
#  bid_cents      :integer
#  custom_fields  :jsonb            not null
#  email          :string
#  first_name     :string
#  last_name      :string
#  phone          :string
#  profit_cents   :integer
#  revenue_cents  :integer
#  score          :integer
#  status         :integer          default("current")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer
#  api_request_id :uuid
#
# Indexes
#
#  index_leads_on_api_request_id  (api_request_id)
#
class Lead < ApplicationRecord
  acts_as_tenant :account

  # Association for the inbound API request
  belongs_to :api_request, optional: true

  # For the many-to-many relationship with outbound API requests
  has_many :api_request_leads
  has_many :api_requests, through: :api_request_leads
  
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :leads, partial: "leads/index", locals: {lead: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :leads, target: dom_id(self, :index) }
  before_destroy :remove_dependent_api_request_leads

  enum :status, %i(current accepted rejected sold duplicate fraudulent)

  #validates :api_ping_id, uniqueness: { message: 'A lead already exists for this ping ID' }

  private

  def remove_dependent_api_request_leads
    api_request_leads.destroy_all
  end
end
