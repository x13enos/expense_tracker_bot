class TelegramController < Telegram::Bot::UpdatesController
  def start(ta = nil, *)
    response = I18n.t('telegram.users.greeting_user', name: current_user.first_name)
    respond_with :message, text: response
  end

  def current_user
    @current_user ||= UserInitService.new(from).perform
  end
end