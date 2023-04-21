class SourcesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_source, only: [:show, :edit, :update, :destroy]

    def new
      @source = Source.new
      @companies = Company.all
    end
  
    def create
      @company = Company.find(params[:company_id])
      @source = @company.sources.build(source_params)
  
      if @source.save
        redirect_to company_path(@source.company, anchor: 'sources')
      else
        redirect_to @company, alert: 'Failed to create source. Please check the input.'
      end
    end

    def edit
    end
  
    def update
      if @source.update(source_params)
        redirect_to company_path(@source.company, anchor: 'sources'), notice: t(".updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @source.destroy
      redirect_to sources_path, status: :see_other, notice: t(".destroyed")
    end
  
    private

    def set_source
      @source = Source.find(params[:id])
    end
  
    def source_params
      params.require(:source).permit(:company_id,:terms, :status, :landing_page_url, :privacy_policy_url, 
        :postback_url, :payout_method, :payout_type, :payout, :payout_cap, :ping_cap, :budget)
    end
end
  