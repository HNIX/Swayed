class PostingInstructionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show], raise: false

  def show
    @source = Source.find_by(secure_token: params[:token])
    render_not_found if @source.nil?
  end

  private

  def render_not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end
end
