class CompaniesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_company, only: [:show, :edit, :update, :destroy]

    ITEMS_PER_PAGE = 7
  
    def index
      @company = Company.new
      @company.contacts.build
      
      paginate_companies
      @permitted_params = params.permit(:current_page)
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

    def paginate_companies
      total_pages = (Company.all.count / ITEMS_PER_PAGE.to_f).ceil
      current_page = (params[:companies_page] || 1).to_i
      current_page = [1, [current_page, total_pages].min].max
  
      @companies = Company.all.order(updated_at: :asc).offset((current_page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
      @companies_pagination = { current_page: current_page, total_pages: total_pages }
    end
end
  