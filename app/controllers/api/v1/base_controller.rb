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
    @token ||= if token_in_cookies?
                 token_from_cookies
               else
                 token_from_headers
               end
  end

  def token_in_cookies?
    cookies[:token].present?
  end

  def token_from_cookies
    cookies.delete(:token)
  end

  def token_from_headers
    return false unless request.env['HTTP_AUTHORIZATION']
    request.env['HTTP_AUTHORIZATION']
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
                        AuthService.decode(parse_token)
                      rescue JWT::ExpiredSignature
                        false
                      end
  end

  def parse_token
    token.scan(/Bearer (.*)$/).flatten.last
  end
end
