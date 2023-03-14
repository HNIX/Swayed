class LeadsController < ApplicationController
    def create
        # Parse the incoming JSON request body
        lead_data = JSON.parse(request.body.read)

        # Filter out the standard fields (assuming they're fixed)
        custom_fields = lead_data.except("first_name", "last_name", "email", "phone")

        # Create a new lead object with the standard fields
        lead = Lead.new(lead_data.slice("first_name", "last_name", "email", "phone"))

        # Set the custom fields on the lead object
        lead.custom_fields = custom_fields

        if lead.save
            render json: { message: "Lead created successfully" }, status: :created
        else
            render json: { errors: lead.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def ping
        lead_data = params[:lead]
    
        # Apply any necessary lead filters here
        filtered_lead_data = filter_lead_data(lead_data)
    
        # Distribute the lead data to multiple buyers or affiliates
        buyers.each do |buyer|
            send_lead_to_buyer(filtered_lead_data, buyer)
        end
    end
    
    private
    
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
            filtered_lead_data = lead_data.slice(:name, :email, :phone)
        
            # Log any filtered data, if necessary
            Rails.logger.info "Filtered lead data: #{filtered_lead_data}"
        
            filtered_lead_data
        end
end

