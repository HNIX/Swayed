class Api::InboundBaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_accepted_latest_agreements!
  before_action :authenticate_api_token, :set_account, :validate_company, :check_ping_limits


  private

  def set_account
    @account = @_affiliate_token.account
  end

  def authenticate_api_token
    #@api_token = params[:api_token]
    @api_token = request.headers.fetch("Authorization", "").split(" ").last

    if @api_token.blank?
      render json: { error: true, message: "Authorization token is missing." }, status: :unauthorized
      return
    end

    #@company = Company.find_by(api_token: @api_token)
    @_affiliate_token ||= AffiliateToken.find_by(token: @api_token)

    unless @_affiliate_token
      render json: { error: true, message: "Invalid Authorization token." }, status: :unauthorized
      return
    end

    @_affiliate_token.touch(:last_used_at) 
  end

  def validate_company
    @company =  @_affiliate_token.company
    
    unless @campaign_source = CampaignSource.find_by(id: params[:id])
      render json: { error: true, message: "Invalid Campaign ID." }, status: :unauthorized
      return
    end

    if @company != @campaign_source.source.company
      render json: { error: true, message: "Company is not associated with the campaign." }, status: :unauthorized
      return
    end
  end

  def check_ping_limits
    if @campaign_source.over_api_ping_limit?(@campaign_source)
      render json: { error: true, message: "API ping limit exceeded." }, status: :unprocessable_entity
    end
  end

  def validate_filters
    if @campaign.filters_invalid?(params)
      render json: { error: true, message: "Data did not pass the campaign filters." }, status: :unprocessable_entity
    end
  end
end
