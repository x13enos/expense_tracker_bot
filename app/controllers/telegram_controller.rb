class TelegramController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def start(ta = nil, *)
    response = t('telegram.users.greeting_user', name: current_user.first_name)
    respond_with :message, text: response
  end

  def message(message)
    result = TransactionHandleService.new(message, current_user).perform
    respond_with :message, text: result
  end

  def balance
    result = BalanceCalculateService.new(current_user).perform
    respond_with :message, text: result
  end

  def help(*)
    response = t('telegram.help')
    respond_with :message, text: response, parse_mode: "Markdown"

  end

  def categories(*)
    categories_list = CategoriesListService.new(current_user).perform
    respond_with :message, text: categories_list, parse_mode: "Markdown"
  end

  def newcategory(*)
    save_context(:new_category_type)
    respond_with :message, text: t('telegram.categories.new.what_type'), reply_markup: {
        keyboard: [t('telegram.categories.types')],
        one_time_keyboard: true
      }
  end

  context_handler :new_category_type do |*category_type|
    result = CategoryTypeCheckService.new(category_type, user_session).perform
    save_context(result[:context_handler])
    respond_with :message, result[:markup]
  end

  context_handler :new_category_name do |*name|
    result = CategoryCreateService.new(current_user, name, user_session[:category_type]).perform
    save_context(:new_category_name) if result[:status] == :error
    respond_with :message, text: result[:message]
  end

  private

  def current_user
    @current_user ||= UserInitService.new(from).perform
  end

  def user_session
    session[current_user.id] || session[current_user.id] = {}
  end
end
