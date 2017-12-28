class SessionsController < ApplicationController
  def index
    cookies[:token] = params[:token]
    redirect_to root_path
  end
end
