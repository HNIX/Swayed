class BiddingService
  def self.process_ping(ping)
    bids = BidService.send_ping_to_buyers(ping)
    {success: true, highest_bid: bids, ping_id: ping.id}

    # ping = ApiPing.new(params)

    # if ping.save
    #     bids = BidService.send_ping_to_buyers(ping)
    #     highest_bid = bids.max_by(&:amount)
    #     { success: true, highest_bid: highest_bid, ping_id: ping.id }
    # else
    #     { success: false, errors: ping.errors.full_messages }
    # end
  end
end
