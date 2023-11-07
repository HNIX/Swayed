# == Schema Information
#
# Table name: distributions
#
#  id                        :bigint           not null, primary key
#  conditional_logic_enabled :boolean
#  endpoint                  :string
#  headers                   :boolean
#  headers_option            :boolean
#  key                       :string
#  name                      :string
#  request_body_all_fields   :boolean
#  request_format            :integer
#  request_method            :integer
#  response_format           :string
#  response_mapping          :jsonb
#  select_fields             :boolean
#  status                    :integer
#  template                  :jsonb
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  company_id                :bigint           not null
#
# Indexes
#
#  index_distributions_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Distribution < ApplicationRecord
  after_initialize :set_default_response_mapping

  belongs_to :company
  
  has_many :campaign_distributions
  has_many :campaigns, through: :campaign_distributions
  has_many :api_requests
  has_many :leads, through: :api_requests  
  has_many :headers, dependent: :destroy

  accepts_nested_attributes_for :headers, allow_destroy: true, :reject_if => :all_blank

  enum request_method: { get: 0, post: 1, put: 2, patch: 3 }
  enum request_format: { form: 0, json: 1, xml: 2 }

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :distributions, partial: "distributions/index", locals: {distribution: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :distributions, target: dom_id(self, :index) }

  # Presence Validations
  validates :name, presence: true
  validates :endpoint, presence: true
  validates :request_method, presence: true
  validates :request_format, presence: true

  # Inclusion Validations
  validates :request_method, inclusion: { in: request_methods.keys, message: "%{value} is not a valid request method" }
  validates :request_format, inclusion: { in: request_formats.keys, message: "%{value} is not a valid request format" }

  # Length Validations
  validates :name, length: { minimum: 3, maximum: 100 }

  private

  def set_default_response_mapping
    self.response_mapping ||= {}
  end
end
