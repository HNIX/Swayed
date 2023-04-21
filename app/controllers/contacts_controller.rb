class ContactsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_contact, only: [:show, :edit, :update, :destroy]

    def create
      @company = Company.find(params[:company_id])
      @contact = @company.contacts.build(contact_params)
  
      if @contact.save
        redirect_to @company, notice: 'Contact was successfully created.'
      else
        redirect_to @company, alert: 'Failed to create contact. Please check the input.'
      end
    end
  
    def edit
    end
  
    def update
      if @contact.update(contact_params)
        redirect_to company_path(@contact.company), notice: t(".updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @contact.destroy
      redirect_to contacts_path, status: :see_other, notice: t(".destroyed")
    end
  
    private
  
    def set_contact
      @contact = Contact.find(params[:id])
    end
    
    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :email, :phone)
    end
  
  end
  