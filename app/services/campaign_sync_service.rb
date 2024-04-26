class CampaignSyncService
    def initialize(campaign)
        @campaign = campaign
    end

    def sync_fields
        base_vertical = Vertical.first
        sync_fields_from_vertical(base_vertical)
        sync_fields_from_vertical(@campaign.vertical)
    end

    private

    def sync_fields_from_vertical(vertical)
        vertical.fields.each do |field|
        sync_field(field)
        end
    end

    def sync_field(field)
        campaign_field = @campaign.campaign_fields.find_or_initialize_by(name: field.name)
        campaign_field.update(
        name: field.name,
        data_type: field.data_type,
        post_required: field&.post_required
        )
    end
end
  