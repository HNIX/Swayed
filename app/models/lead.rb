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
#  status        :integer          default("new")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :integer
#
class Lead < ApplicationRecord
  acts_as_tenant :account
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :leads, partial: "leads/index", locals: {lead: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :leads, target: dom_id(self, :index) }

  enum :status, %i(new accepted rejected sold duplicate fraudulent)
end
