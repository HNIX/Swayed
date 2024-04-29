# app/decorators/article_decorator.rb
class CampaignDecorator < Draper::Decorator
  delegate_all

  def overall_acceptance_rate
    calculate_acceptance_rate(object.leads)
  end

  def overall_revenue
    calculate_total(object.leads, :revenue_cents)
  end

  def overall_profit
    calculate_total(object.leads, :profit_cents)
  end

  def recent_leads(n = nil)
    n.nil? ? leads.joins(:api_request).where(api_requests: {status: "accepted"}).order("leads.created_at DESC") : leads.joins(:api_request).where(api_requests: {status: "accepted"}).where("leads.created_at >= ?", n.days.ago).order("leads.created_at DESC")
  end

  def sold_leads(n = nil)
    n.nil? ? leads.joins(:api_request).where(api_requests: {status: "accepted"}).where(leads: {status: :sold}).order("leads.created_at DESC") : leads.joins(:api_request).where(api_requests: {status: "accepted"}).where("leads.created_at >= ?", n.days.ago).where(leads: {status: :sold}).order("leads.created_at DESC")
  end

  def sold_leads_count(n = nil)
    sold_leads(n).count
  end

  def recent_leads_count(n = nil)
    recent_leads(n).count
  end

  def ping_rejection_rate(n = nil)
    rejected_pings = recent_rejected_ping_count(n)
    total_pings = recent_inbound_api_requests_count(n)

    return 0 if total_pings.zero? || rejected_pings.zero? # Also handle case where rejected_pings might be zero
    ((rejected_pings.to_f / total_pings) * 100).round(0)
  end

  def recent_acceptance_rate(n = nil)
    accepted_pings = recent_accepted_ping_count(n)
    total_pings = recent_inbound_api_requests_count(n)

    return 0 if total_pings.zero? || accepted_pings.zero?
    ((accepted_pings.to_f / total_pings) * 100).round(0)
  end

  def recent_sale_rate(n = nil)
    sold_leads = sold_leads_count(n)
    total_accepted_leads = recent_leads(n).count

    return 0 if sold_leads.zero?
    ((sold_leads.to_f / total_accepted_leads) * 100).round(0)
  end

  def recent_revenue(n = nil)
    calculate_total(sold_leads(n), :revenue_cents)
  end

  def recent_cost(n = nil)
    recent_revenue(n) - recent_profit(n)
  end

  def recent_profit(n = nil)
    calculate_total(sold_leads(n), :profit_cents)
  end

  def profit_margin(n = nil)
    revenue = recent_revenue(n)
    profit = recent_profit(n)

    if revenue.nil? || revenue.zero?
      0.0 # or any other default value you want to return when revenue is nil or zero
    else
      ((profit / revenue) * 100).round(0)
    end
  end

  # Calculates the change in profit compared to the previous period.
  def profit_change_percentage(n)
    # Calculate profit for the current period (last n days)
    current_period_profit = profit_in_period(n, n.days.ago, Date.current)

    # Calculate profit for the previous period (the n days before the current n days)
    previous_period_profit = profit_in_period((2 * n), (2 * n).days.ago, n.days.ago)

    # Calculate the percentage change
    change_percentage(current_period_profit, previous_period_profit)
  end

  private

  def calculate_acceptance_rate(scope)
    total_leads = scope.count
    return 0 if total_leads.zero?
    accepted_leads = scope.where(status: "accepted").count
    ((accepted_leads.to_f / total_leads) * 100).round
  end

  # Helper method to calculate profit within a given time range
  def profit_in_period(n, start_date, end_date)
    sold_leads(n).where(created_at: start_date...end_date).sum(:profit_cents) / 100.0
  end

  # Helper method to calculate the percentage change between two values
  def change_percentage(current, previous)
    return 0 if previous.zero?
    (((current - previous) / previous.to_f) * 100).round(2)
  end

  def calculate_total(scope, field)
    scope.sum(field) / 100.0
  end

  def recent_inbound_api_requests_count(n)
    n.nil? ? object.api_requests.where(direction: "inbound").count : object.api_requests.where(direction: "inbound").where("created_at >= ?", n.days.ago).count
  end

  def recent_accepted_ping_count(n)
    n.nil? ? object.api_requests.where(direction: "inbound", status: "accepted").count : object.api_requests.where(direction: "inbound", status: "accepted").where("created_at >= ?", n.days.ago).count
  end

  def recent_rejected_ping_count(n)
    n.nil? ? object.api_requests.where(direction: "inbound", status: "rejected").count : object.api_requests.where(direction: "inbound", status: "rejected").where("created_at >= ?", n.days.ago).count
  end
end
