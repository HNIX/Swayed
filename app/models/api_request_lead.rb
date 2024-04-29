# == Schema Information
#
# Table name: api_request_leads
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  api_request_id :uuid
#  lead_id        :bigint           not null
#
# Indexes
#
#  index_api_request_leads_on_api_request_id  (api_request_id)
#  index_api_request_leads_on_lead_id         (lead_id)
#
# Foreign Keys
#
#  fk_rails_...  (lead_id => leads.id)
#
class ApiRequestLead < ApplicationRecord
  belongs_to :api_request
  belongs_to :lead
end
