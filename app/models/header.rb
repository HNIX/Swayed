# == Schema Information
#
# Table name: headers
#
#  id              :bigint           not null, primary key
#  header_value    :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  distribution_id :bigint
#
# Indexes
#
#  index_headers_on_distribution_id  (distribution_id)
#
# Foreign Keys
#
#  fk_rails_...  (distribution_id => distributions.id)
#
class Header < ApplicationRecord
  belongs_to :distribution
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :headers, partial: "headers/index", locals: {header: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :headers, target: dom_id(self, :index) }

  HEADER_VALUES = %w[Accept Accept-Charset Accept-Encoding Accept-Language Accept-Datetime Authorization Cache-Control Connection].freeze

  validates :name, presence: true, uniqueness: {scope: :distribution_id}
  validates :header_value, presence: true
end
