class UniqueNameGeneratorService
  def initialize(campaign)
    @campaign = campaign
  end

  def generate
    base_name = [@campaign.campaign_type.titleize, @campaign.vertical.secondary_category.titleize, @campaign.distribution_method.titleize].join(" - ")
    "#{base_name} #{Time.now.to_i}"
  end
end
