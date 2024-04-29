class Api::InboundBaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_accepted_latest_agreements!
  prepend_before_action :authenticate_token!

  private

  def authenticate_token!
    if affiliate_token.present? && account.present?
      affiliate_token.touch(:last_used_at)
    else
      head :unauthorized
    end
  end

  def token_from_header
    request.headers.fetch("Authorization", "").split(" ").last
  end

  def affiliate_token
    @token ||= AffiliateToken.find_by(token: token_from_header)
  end

  def account
    @account = affiliate_token.account
  end
end
