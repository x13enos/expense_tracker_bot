class CategoryTypeCheckService
  attr_accessor :user_session, :category_type

  def initialize(type, user_session)
    self.user_session = user_session
    self.category_type = parse_category_type(type)
  end

  def perform
    if category_type_valid?
      user_session[:category_type] = category_type
      success_result
    else
      fail_result
    end
  end

  private

  def success_result
    {
      markup: { text: I18n.t("telegram.categories.new.fill_the_name")  },
      context_handler: :new_category_name
    }
  end

  def fail_result
    {
      markup: {
        text: I18n.t("telegram.categories.new.wrong_type"),
        reply_markup: { keyboard: [I18n.t('telegram.categories.types')], one_time_keyboard: true }
      },
      context_handler: :new_category_type
    }
  end

  def category_type_valid?
    Category::FINANCIAL_TYPES.include?(category_type)
  end

  def parse_category_type(type)
    type[0].downcase
  end
end
