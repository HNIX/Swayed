require "net/http"
require "json"

class BidService
  def self.send_ping_to_buyers(ping)
    bids = []
    # Send the ping data to multiple buyers and capture their bids
    ping.campaign.campaign_distributions.each do |cd|
      endpoint = cd.distribution.endpoint
      field_mapping = cd.field_mapping
      json_body_template = cd.distribution.template

      response = send_ping(ping, endpoint, field_mapping, json_body_template)

      bid_token = cd.distribution.response_mapping["bid"] # buyer bid response token

      # Check if the response is successful (HTTP status code 200)
      if response.is_a?(Net::HTTPSuccess)
        # Get the response body
        response_body = response.body

        # Parse the response body (JSON)
        parsed_response = JSON.parse(response_body)

        # Access the desired value using its key
        # ... (your code to access JSON values)
      else
        # Handle the error (e.g., log the error or display a message)
        puts "Error: #{response.code} - #{response.message}"
      end

      bid = parsed_response[bid_token] # buyer bid response token
      bids << bid if bid.present?
    end

    bids
  end

  def extract_bid_value(bid_response, bid_key = "bid")
    bid_key = "bid" if bid_key.blank?

    bid_response[bid_key]
  end

  def self.send_ping(ping_data, endpoint, field_mapping, json_body_template = nil)
    if json_body_template.nil?
      # Create a new JSON object based on the mapped fields
      json_ping_data = {}

      field_mapping.each do |original_field, mapped_field|
        json_ping_data[mapped_field] = ping_data[original_field]
      end

      json_ping_data = json_ping_data.to_json
    else
      # Load the JSON template
      json_template = JSON.parse(json_body_template)
      stripped_template = strip_values_from_template(json_template)

      # Map the ping data to the JSON template based on the field mapping
      mapped_json = map_fields_to_json(ping_data, field_mapping, stripped_template)

      # Convert the mapped JSON template to JSON
      json_ping_data = mapped_json.to_json
    end

    print json_ping_data

    # Send the request and capture the response
    uri = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    request = Net::HTTP::Post.new(uri.request_uri, "Content-Type" => "application/json")
    request.body = json_ping_data

    response = http.request(request)

    print response

    # Return the response
    response
  end

  def replace_value(hash, key_to_replace, new_value)
    if hash.has_key?(key_to_replace)
      hash[key_to_replace] = new_value
    else
      hash.each_value do |value|
        replace_value(value, key_to_replace, new_value) if value.is_a?(Hash)
      end
    end
  end

  def strip_values_from_template(json_template)
    json_template.transform_values do |value|
      if value.is_a?(Hash)
        strip_values_from_template(value)
      else
        ""
      end
    end
  end

  def map_fields_to_json(ping_data, field_mapping, json_template = {})
    field_mapping.each do |original_field, mapped_field|
      new_value = ping_data[original_field]
      replace_value(json_template, mapped_field, new_value)
    end

    json_template
  end
end
