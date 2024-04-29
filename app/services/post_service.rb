require "net/http"
require "json"

class PostService
  def post_lead(buyer, lead_data)
    # ... code to send data using HTTParty or Faraday

    ApiRequestLog.create!(
      campaign: @campaign,
      buyer: buyer,
      request_type: "outgoing",
      endpoint: buyer.api_endpoint,
      method_type: "POST", # or whatever method you use
      headers: constructed_headers, # the headers you sent
      payload: lead_data.to_json, # or XML or other formats
      response_body: response.body, # response from the buyer's system
      response_status: response.code,
      request_time: DateTime.now
    )
  end
end
