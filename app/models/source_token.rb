# == Schema Information
#
# Table name: source_tokens
#
#  id           :bigint           not null, primary key
#  expires_at   :datetime
#  last_used_at :datetime
#  metadata     :jsonb
#  name         :string
#  token        :string
#  transient    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint
#  source_id    :bigint
#
# Indexes
#
#  index_source_tokens_on_account_id  (account_id)
#  index_source_tokens_on_name        (name) UNIQUE
#  index_source_tokens_on_source_id   (source_id) UNIQUE
#  index_source_tokens_on_token       (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (source_id => sources.id)
#
class SourceToken < ApplicationRecord
  acts_as_tenant :account

  DEFAULT_NAME = I18n.t("api_tokens.default")
  APP_NAME = I18n.t("api_tokens.app")

  belongs_to :source

  scope :sorted, -> { order("last_used_at DESC NULLS LAST, created_at DESC") }

  has_secure_token :token

  validates :name, presence: true, uniqueness: true
  validates_uniqueness_of :token

  def can?(permission)
    Array.wrap(data("permissions")).include?(permission)
  end

  def cant?(permission)
    !can?(permission)
  end

  def data(key, default: nil)
    (metadata || {}).fetch(key, default)
  end

  def expired?
    expires_at? && Time.current >= expires_at
  end

  def touch_last_used_at
    return if transient?
    update(last_used_at: Time.current)
  end

  def generate_token
    loop do
      self.token = SecureRandom.hex(16)
      break unless SourceToken.where(token: token).exists?
    end
  end

  def refresh_token!
    update(token: SecureRandom.hex(10), last_used_at: nil)
  end
end
