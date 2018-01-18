class WebsiteLinkGenerateService

  def self.perform(user_id)
    token = AuthService.encode(user_id)
    url = Rails.application.routes.url_helpers.authorize_url(token: token, host: ENV["HOST"])
    "[Your link](#{url})"
  end

end
