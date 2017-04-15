class CategoriesListService
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def perform
    if categories.any?
      [income_categories, expense_categories].compact.join("\n\n")
    else
      I18n.t('telegram.categories.you_do_not_have_categories')
    end
  end

  private

  def income_categories
    if categories.income.any?
      ([I18n.t("telegram.categories.income")] + categories.income.pluck(:name)).join("\n")
    end
  end

  def expense_categories
    if categories.expense.any?
      ([I18n.t("telegram.categories.expense")] + categories.expense.pluck(:name)).join("\n")
    end
  end

  def categories
    @categories ||= user.categories
  end
end
