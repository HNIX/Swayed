class DistributionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_distribution, only: [:show, :edit, :update, :destroy]

    def new
      @distribution = Distribution.new
      @companies = Company.all
    end
  
    def create
      @company = Company.find(params[:company_id])
      @distribution = @company.distributions.build(distribution_params)
  
      if @distribution.save
        redirect_to company_path(@distribution.company)
      else
        redirect_to @company, alert: 'Failed to create distribution. Please check the input.'
      end
    end

    def edit
    end
  
    def update
      if @distribution.update(distribution_params)
        redirect_to company_path(@distribution.company), notice: t(".updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @distribution.destroy
      redirect_to distributions_path, status: :see_other, notice: t(".destroyed")
    end
  
    private

    def set_distribution
      @distribution = distribution.find(params[:id])
    end
  
    def distribution_params
      params.require(:distribution).permit(:company_id, :endpoint, :key, :response_format, :status, response_mapping: [:bid, :status, :message])
    end
end
  