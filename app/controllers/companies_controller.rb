class CompaniesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_company, only: [:show, :edit, :update, :destroy]
  
    def index
      @pagy, @companies = pagy(Company.all.order('created_at DESC'), items: 6)
    end
  
    def new
      @company = Company.new
      @company.contacts.build
    end
  
    def create
      @company = Company.new(company_params)

      if @company.save  
        respond_to do |format|
          format.html { redirect_to @company, notice: t(".created") }
          format.json { render json: @company }
          format.turbo_stream
        end
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream
        end
      end
    end
  
    def edit
    end
  
    def update
      if @company.update(company_params)
        redirect_to company_path(@company), notice: t(".updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @company.destroy
      redirect_to companies_path, status: :see_other, notice: t(".destroyed")
    end
    
    def field_field
    end

    def show
    end
  
    private
  
    def set_company
      @company = Company.find(params[:id])
    end
  
    def company_params
      params.require(:company).permit(:name, :address, :city, :state, :zip_code, :billing_cycle, :notes, :payment_terms, :currency, contacts_attributes: [:first_name, :last_name, :email, :id, :phone])
    end

end
  