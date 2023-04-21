class AffiliateTokensController < ApplicationController
  before_action :authenticate_user!
  before_action :set_affiliate_token, only: [:show, :edit, :update, :destroy]

  def index
    @affiliate_tokens = AffiliateToken.all.sorted
  end

  def new
    @affiliate_token = AffiliateToken.new
  end

  def create
    @affiliate_token = AffiliateToken.new(affiliate_token_params)
    
    if @affiliate_token.save
      redirect_to @affiliate_token, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @affiliate_token.update(affiliate_token_params)
      redirect_to affiliate_token_path(@affiliate_token), notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @affiliate_token.destroy
    redirect_to affiliate_tokens_path, status: :see_other, notice: t(".destroyed")
  end

  private

  def set_affiliate_token
    @affiliate_token = AffiliateToken.find(params[:id])
  end

  def affiliate_token_params
    params.require(:affiliate_token).permit(:name, :company_id)
  end
end
