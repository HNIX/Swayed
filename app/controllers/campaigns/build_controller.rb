class Campaigns::BuildController < ApplicationController
  include Wicked::Wizard

  steps :basic_setup, :data_config, :sources, :distributions, :mapping, :finalize

  def show
    @campaign = Campaign.find(params[:campaign_id])

    case step
    when :sources
      @companies = Company.all

    when :distributions
      @companies = Company.all

      @distributions = Distribution.all - @campaign.distributions
    when :mapping
      @campaign.campaign_distributions.each do |campaign_distribution|
        # Build a new blank mapped field for each distribution
        campaign_distribution.mapped_fields.build
      end
    end

    render_wizard
  end

  def update
    @campaign = Campaign.find(params[:campaign_id])
    params[:campaign][:status] = "active" if step == steps.last

    case step
    when :sources
      @companies = Company.all
    end

    if @campaign.update(campaign_params)
      flash[:notice] = "Changes saved."

      if params[:save_and_stay]
        redirect_to wizard_path(step)
      else
        render_wizard @campaign
      end
    else
      flash[:alert] = "There was an error saving your changes."
      render_wizard @campaign
    end
  end

  def create
    @campaign = Campaign.create
    redirect_to wizard_path(steps.first, campaign_id: @campaign.id)
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :status, :campaign_type, :description, :distribution_schedule_enabled,
      :distribution_method, :distribution_schedule_start_time, :distribution_schedule_end_time, :vertical_id,
      campaign_fields_attributes: [:position, :name, :label, :data_type, :id, :ping_required, :post_required, :post_only, :_destroy],
      sources_attributes: [:id, :company_id, :budget, :description, :integration_type, :landing_page_url, :margin, :minimum_acceptable_bid, :name, :offer_type, :payout, :payout_method, :postback_url, :privacy_policy_url, :status, :terms],
      campaign_distributions_attributes: [:id, :distribution_id, :_destroy, field_mapping: params[:campaign][:campaign_distributions_attributes]&.each_value&.map { |cd| cd[:field_mapping]&.keys }&.flatten, mapped_fields_attributes: [:static_value, :id, :name, :campaign_field_id, :_destroy]],
      distribution_schedule_days: [],
      distribution_ids: [],
      distributions_attributes: [:id, :endpoint, :key, :name, :request_method, :request_format, :company_id, headers_attributes: [:id, :name, :header_value]])
  end

  def all_distributions_fully_mapped?(campaign)
    campaign.campaign_distributions.all?(&:fully_mapped?)
  end
end
