class SourceTokensController < ApplicationController
  before_action :authenticate_user!
  before_action :set_source_token, only: [:show, :edit, :update, :destroy, :refresh_token]

  def index
    @source_tokens = SourceToken.all.sorted
  end

  def new
    @source_token = SourceToken.new
  end

  def create
    @source_token = SourceToken.new(source_token_params)
    
    if @source_token.save
      redirect_to @source_token, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @source_token.update(source_token_params)
      redirect_to source_token_path(@source_token), notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @source_token.destroy
    redirect_to source_tokens_path, status: :see_other, notice: t(".destroyed")
  end

  # POST /source_tokens/:id/refresh_token
  def refresh_token
    @source_token.refresh_token!
    redirect_to campaign_sources_path(@source_token.source.campaign), notice: 'Source token has been refreshed successfully.'
  end

  private

  def set_source_token
    @source_token = SourceToken.find(params[:id])
  end

  def source_token_params
    params.require(:source_token).permit(:name, :source_id)
  end
end
