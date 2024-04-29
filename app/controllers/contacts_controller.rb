class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_company
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def create
    @contact = @company.contacts.build(contact_params)

    if @contact.save
      redirect_to company_path(@company), notice: "Contact was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @contact.update(contact_params)
      redirect_to company_path(@company), notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    redirect_to company_path(@company), status: :see_other, notice: t(".destroyed")
  end

  private

  def get_company
    @company = Company.find(params[:company_id])
  end

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :phone)
  end
end
