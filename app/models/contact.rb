# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  email      :string
#  first_name :string
#  last_name  :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint           not null
#
# Indexes
#
#  index_contacts_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Contact < ApplicationRecord
  belongs_to :company
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :contacts, partial: "contacts/index", locals: {contact: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :contacts, target: dom_id(self, :index) }

  scope :sorted, -> { order("created_at DESC") }


  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def name
    "#{first_name} #{last_name}"
  end
end
