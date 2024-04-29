class Api::V1::LeadsController < Api::InboundBaseController
  before_action :set_campaign_source, only: [:ping, :create]
  before_action :check_ping_limits, only: :ping
  before_action :check_duplicate_ping, only: :ping
  before_action :validate_filters, only: :ping

  before_action :set_ping, only: :create

  # POST /api/v1/leads
  def create
    @lead = current_user.leads.build(lead_params)

    if @lead.save
      render json: @lead, status: :created
    else
      render json: {errors: @lead.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # POST /api/v1/leads/ping
  def ping
    # Parse request parameters as JSON or URL parameters
    ping_lead_params = if request.content_type == "application/json"
      JSON.parse(request.body.read)
    else
      params[:lead]
    end

    ping_request = ApiPing.new(
      account_id: params[:account_id],
      campaign_source_id: campaign_source.id,
      endpoint: params[:controller],
      action: params[:action],
      request_body: ping_lead_params,
      headers: show_headers,
      request_method: request.headers.fetch("REQUEST_METHOD", "").split(" ").last
    )

    unless ping_request.save
      # Handle the error if the request is not saved.
      Rails.logger.error("Failed to save the request to the database: #{ping_request.errors.full_messages.join(", ")}")

      # Respond with an error status and message to the client.
      render json: {error: true, message: "Failed to save the request to the database."}, status: :internal_server_error
    end

    # Array to store buyer bids
    buyer_bids = []

    # Loop through the buyers associated with the campaign
    @campaign.buyers.each do |buyer|
      # Send the lead data to each buyer's API endpoint and capture the bid from the response
      # You'll need to implement the logic for making the API request and capturing the bid here
      # For example, you might use Faraday or RestClient to make HTTP requests to buyers' API endpoints
      # and parse the response to extract the bid value
      buyer_bid = make_api_request_to_buyer(buyer, @lead)
      buyer_bids << buyer_bid
    end

    # Get the highest bid from the array of buyer bids
    highest_bid = buyer_bids.max

    # Now you have the highest bid, and you can process it as needed
    # For example, you might associate it with the lead or use it for other purposes

    # Return the highest bid in the ping response
    render json: {highest_bid: highest_bid}
  end

  private

  def set_campaign_source
    unless campaign_source.present?
      head :unauthorized
    end
  end

  def company_from_token
    @token.company
  end

  def campaign_source
    CampaignSource.find_by(campaign_id: params[:campaign_id], company_id: company_from_token.id)
  end

  def check_ping_limits
    if campaign_source.over_api_ping_limit? || @campaign.api_ping_limit_reached?
      render json: {error: true, message: "API limit exceeded."}, status: :unprocessable_entity
    end
  end

  def check_duplicate_ping
    if ApiPing.duplicate?(request.raw_post, params)
      render json: {errors: "Duplicate ping"}, status: :unprocessable_entity
      nil
    end
  end

  def validate_filters
    if @campaign.filters_invalid?(params)
      render json: {error: true, message: "Data did not pass the campaign filters."}, status: :unprocessable_entity
    end
  end

  def set_ping
    unless params[:ping_id]
      render json: {error: true, message: "Missing ping ID"}, status: :unauthorized
      return
    end

    unless @api_ping ||= ApiPing.find_by(id: params[:ping_id])
      render json: {error: true, message: "Invalid ping ID"}, status: :unauthorized
      nil
    end
  end

  def show_headers
    raw_headers = request.headers
    # If you need to filter out only the HTTP headers:
    raw_headers.select { |k, _| k.start_with?("HTTP_") }
  end
end
