class Api::V1::CampaignSourcesController < Api::InboundBaseController
    #before_action :check_api_ping_limit
    set_current_tenant_through_filter
    before_action :set_tenant
    before_action :check_duplicate_ping, only: :ping
    before_action :set_ping, only: :post
    skip_before_action :authenticate_token, :set_account, :validate_company, :check_ping_limits, only: :test_buyer, :raise => false

    def ping
        if api_ping = create_ping
          #ping buyers
          #get bids

          response = BiddingService.process_ping(api_ping)
          
          if !response[:highest_bid].blank?
            render json: response
          else
            render json: { status: 'Error', message: "No buyers" }, status: :unprocessable_entity
          end

          # # Apply any necessary lead filters here
          # filtered_lead_data = filter_lead_data(lead_data)
      
          # # Distribute the lead data to multiple buyers or affiliates
          # buyers.each do |buyer|
          #     send_lead_to_buyer(filtered_lead_data, buyer)
          # end

          # render json: { status: 'Success', ping_id: api_ping.id }, status: :ok
        else
          render json: { error: 'No Ping' }, status: :too_many_requests
        end
    end

    def post
      create_lead
    end

    def direct
     
    end

    def test_buyer
      render json: { status: "Success", ping_id: 33, bid: 10.54 }, status: :ok
    end

    private
      
    def check_api_ping_limit
      if @campaign.api_ping_limit_reached?
        render json: { error: 'API ping limit reached for this campaign' }, status: :too_many_requests
      end
    end

    def check_duplicate_ping
      if ApiPing.duplicate?(request.raw_post, params)
        render json: { errors: 'Duplicate ping detected' }, status: :unprocessable_entity
        return
      end
    end
  
    def set_tenant
      set_current_tenant(@account)
    end 

    def set_ping
      
      unless params[:ping_id]
        render json: { error: true, message: "Missing ping ID" }, status: :unauthorized
        return
      end

      unless @api_ping ||= ApiPing.find_by(id: params[:ping_id])
        render json: { error: true, message: "Invalid ping ID" }, status: :unauthorized
        return
      end
      
    end 
  
    def create_ping
      headers = show_headers
      campaign_source = CampaignSource.find(params[:id])
  
      api_ping = ApiPing.create(
        account_id: @account.id, 
        campaign_source_id: campaign_source.id, 
        endpoint: params[:controller], 
        action: params[:action], 
        request_body: request.raw_post,
        headers: headers,
        host: request.headers.fetch("Host", "").split(" ").last,
        request_method: request.headers.fetch("REQUEST_METHOD", "").split(" ").last
      )
    end

    def create_lead
      headers = show_headers
      # Parse the incoming JSON request body
      lead_data = JSON.parse(request.body.read)
      
      # Filter out the standard fields (assuming they're fixed)
      custom_fields = lead_data.except("first_name", "last_name", "email", "phone")

      # Create a new lead object with the standard fields
      lead = Lead.new(lead_data.slice("first_name", "last_name", "email", "phone"))
  
      lead.account_id = @account.id
      lead.api_ping_id = @api_ping.id
       
      # Set the custom fields on the lead object
      lead.custom_fields = custom_fields

      if lead.save
        render json: { message: "Lead created successfully" }, status: :created
      else
        # Handle validation errors
        render json: { errors: lead.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show_headers
      raw_headers = request.headers
      # If you need to filter out only the HTTP headers:
      http_headers = raw_headers.select { |k, _| k.start_with?('HTTP_') }
  
      http_headers
    end

    def buyers(campaign)
      # Retrieve a list of buyers or affiliates from your database
      # or other source, and return it as an array
      campaign.deliveries.each do |delivery|
          buyers = delivery.purchaser
      end
    end

    def send_lead_to_buyer(lead_data, bids)
        # Post the lead to the buyer with the highest bid
        if bid.amount == bids.maximum(:amount)
            response = HTTParty.post(buyer.post_url, body: lead_data.to_json)
            
            if response.status.success?
                # Lead successfully posted to buyer
            else
                # Error posting lead to buyer
            end
        end
        # Use HTTParty or a similar library to send the lead data to the buyer
        response = HTTParty.post(buyer.endpoint_url, body: lead_data.to_json)
    
        # Log the response and any errors, if necessary
        if response.code == 200
            Rails.logger.info "Lead sent to #{buyer.name}: #{lead_data}"
        else
            Rails.logger.error "Error sending lead to #{buyer.name}: #{response.body}"
        end
    end

    def ping_buyers
        buyers.each do |buyer|
            # Ping the buyer
            response = HTTParty.post(buyer.endpoint_url, body: lead_data.to_json)
                
            if response.status.success?
                # Capture the bid for the lead
                bid = bids.create(buyer: buyer, amount: response.body['bid'])
            else
                # Error pinging buyer
            end
        end
    end

    def filter_lead_data(lead_data)
        # Apply any necessary lead filters here, such as removing
        # sensitive information or validating the data
        filtered_lead_data = lead_data.slice(:first_name, :last_name, :email, :phone)
    
        # Log any filtered data, if necessary
        Rails.logger.info "Filtered lead data: #{filtered_lead_data}"
    
        filtered_lead_data
    end
  
  
  end