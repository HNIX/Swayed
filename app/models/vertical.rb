# == Schema Information
#
# Table name: verticals
#
#  id                 :bigint           not null, primary key
#  archived           :boolean
#  description        :text
#  primary_category   :integer
#  secondary_category :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint           not null
#
# Indexes
#
#  index_verticals_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Vertical < ApplicationRecord
  acts_as_tenant :account

  has_many :campaigns
  has_many :fields, dependent: :destroy
  has_many :companies, through: :campaigns
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :verticals, partial: "verticals/index", locals: {vertical: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :verticals, target: dom_id(self, :index) }

  accepts_nested_attributes_for :fields

  scope :sorted, -> { order("created_at DESC") }

  enum primary_category: { home_services: 0, legal: 1, debt: 2 }

  validates :primary_category, presence: true
  validates :secondary_category, presence: true
  validates_uniqueness_to_tenant :secondary_category

  attribute :archived, :boolean, default: false

  def name 
    "#{primary_category&.titleize} - #{secondary_category&.titleize}"
  end
end
