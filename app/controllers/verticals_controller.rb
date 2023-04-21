class VerticalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vertical, only: [:show, :edit, :update, :destroy]

  def index
    @verticals = Vertical.all.sorted
  end

  def new
    @vertical = Vertical.new
    @vertical.fields.build
  end

  def create
    @vertical = Vertical.new(vertical_params)
    if @vertical.save
      redirect_to @vertical, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    
  end

  def update
    if @vertical.update(vertical_params)
      redirect_to vertical_path(@vertical), notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vertical.destroy
    redirect_to verticals_path, status: :see_other, notice: t(".destroyed")
  end
  
  def field
  end

  private

  def set_vertical
    @vertical = Vertical.find(params[:id])
  end

  def vertical_params
    params.require(:vertical).permit(:name, fields_attributes: [:name, :label, :data_type, :id, :ping_required, :post_required])
  end
end
