class Rack::Attack
    
    throttle('req/ip', limit: 100, period: 1.minute) do |req|
      # Limit requests per IP to 100 requests per minute
        req.ip
    end
  
    ActiveSupport::Notifications.subscribe(/rack_attack/) do |name, start, finish, request_id, payload|
      req = payload[:request]
      if %i[throttle].include? req.env['rack.attack.match_type']
        info = "Remote Ip: #{req.ip}"
        rack_attack_throttle_data = req.env['rack.attack.throttle_data']['req/ip']
        Rails.logger.info info
        Notifier.rack_attack_error_mail(info, rack_attack_throttle_data&.stringify_keys).deliver
      end
    end
  
    Rack::Attack.throttled_responder = lambda do |env|
        # Custom response when a request is throttled
        # You can customize the status code, headers, and body as needed.
        [429, {}, ['Rate limit exceeded. Please try again later.']]
    end
end