class Api::V1::AccountsController < Api::BaseController
  skip_before_action :authenticate_affiliate_token!
  
  def index
    @accounts = current_user.accounts
    render "accounts/index"
  end
end
