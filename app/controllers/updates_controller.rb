class UpdatesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    render plain: params[:payload]
  end
end
