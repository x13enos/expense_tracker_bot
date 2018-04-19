class SessionsController < ApplicationController
  def index
    cookies[:token] = "Bearer #{params[:token]}"
    redirect_to root_path
  end
end
