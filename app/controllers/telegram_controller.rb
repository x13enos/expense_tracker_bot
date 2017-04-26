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

  def report(*)
    report = ReportGenerateService.new(current_user).perform
    respond_with :message, text: report, parse_mode: "Markdown"
  end

  def transactions(*)
    list = TransactionsListService.new(current_user).perform
    respond_with :message, text: list, parse_mode: "Markdown"
  end

  #New category chain
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

  #Delete category chain
  def deletecategory(*category_name)
    if category = current_user.categories.find_by(name: category_name.join(" "))
      save_context(:delete_category_confirmation)
      user_session[:delete_category_id] = category.id
    end
    respond_with :message, text: t("telegram.categories.delete.#{category.present? ? 'type_in_yes' : 'not_found'}")
  end

  context_handler :delete_category_confirmation do |*confirmation_message|
    positive_response = confirmation_message[0].downcase == t('telegram.yes_word')
    current_user.categories.find(user_session[:delete_category_id]).delete if positive_response
    respond_with :message, text: t("telegram.categories.delete.#{positive_response ? 'success' : 'cancel'}")
  end


  private

  def current_user
    @current_user ||= UserInitService.new(from).perform
  end

  def user_session
    session[current_user.id] || session[current_user.id] = {}
  end
end
