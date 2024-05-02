class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Accounts::SubscriptionStatus
  include ActiveStorage::SetCurrent
  include Authentication
  include Authorization
  include CurrentHelper
  include DeviceFormat
  include Pagy::Backend
  include SetCurrentRequestDetails
  include SetLocale
  include Sortable
  include Users::AgreementUpdates
  include Users::NavbarNotifications
  include Users::Sudo
  include Users::TimeZone

  
  before_action :check_app_secret


  protected

  def set_modal_properties
    @padding = !(params[:padding] == "0")
    @advance = params[:advance] == "1"
    @override_url = "/custom-advance-history-url" if @advance
  end

  private

  def check_app_secret
    unless request.headers["X-App-Secret"] == ENV["APP_SECRET"] || params[:secret] == ENV["APP_SECRET"]
      render plain: "Unauthorized", status: :unauthorized
    end
  end
end
