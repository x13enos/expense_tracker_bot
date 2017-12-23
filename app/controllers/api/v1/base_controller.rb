class Api::V1::BaseController < ApplicationController
  before_action :authenticate, if: :format_json?
  after_action :update_token, if: :logged_in?

  def logged_in?
    !!current_user
  end

  def current_user
    if token.present? && decoded_token
      user = User.find(decoded_token)
      if user
        @current_user ||= user
      end
    end
  end

  private

  def authenticate
    authentication_error unless logged_in?
  end

  def format_json?
    request.format == :json
  end

  def token
    return false unless request.env['HTTP_AUTHORIZATION']
    request.env['HTTP_AUTHORIZATION'].scan(/Bearer (.*)$/).flatten
  end

  def authentication_error
    render json: { error: t('authorization.unauthorized') }, status: 401
  end

  def update_token
    response.headers['HTTP_AUTHORIZATION'] = encoded_token
  end

  def encoded_token
    AuthService.encode(current_user.id)
  end

  def decoded_token
    @decoded_token ||= begin
                        AuthService.decode(token.last)
                      rescue JWT::ExpiredSignature
                        false
                      end
  end
end
