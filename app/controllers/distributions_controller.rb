class DistributionsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_campaign, only: [:new, :create, :index, :update, :destroy]
  before_action :set_distribution, only: [:show, :edit, :update, :destroy]

  ITEMS_PER_PAGE = 7

  def new
    @distribution = @campaign.distributions.build
    @companies = Company.all
  end

  def create
    
    @distribution = @campaign.distributions.build(distribution_params)

    if @distribution.save
      @campaign.distributions << @distribution
      redirect_to campaign_distributions_path(@campaign), notice: 'Distribution was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @distribution.update(distribution_params)
        format.html { redirect_to campaign_distribution_path(@campaign, @distribution), notice: 'Distribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @distribution }
      else
        format.html { render :edit }
        format.json { render json: @distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @distribution.destroy
    respond_to do |format|
      format.html { redirect_to campaign_distributions_path(@campaign), notice: 'Distribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def index
    @distributions = @campaign.distributions
  end

  def header
  end

  private
  
  def get_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def set_distribution
    @distribution = @campaign.distributions.find(params[:id])
    @campaign_distribution = @distribution.campaign_distributions.where(campaign: @campaign).first
  end

  def distribution_params
    params.require(:distribution).permit(:company_id, :endpoint, :key, :response_format, :status, response_mapping: [:bid, :status, :message], campaign_distributions_attributes: [:id, :distribution_id, :_destroy, field_mapping: params[:distribution][:campaign_distributions_attributes]&.each_value&.map { |cd| cd[:field_mapping]&.keys }&.flatten])
  end
end



