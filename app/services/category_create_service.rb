class CategoryCreateService
  attr_accessor :user, :category_name, :category_type

  def initialize(user, name, type)
    self.user = user
    self.category_name = parse_category_name(name)
    self.category_type = type
  end

  def perform
    category = user.categories.new(category_params)
    category.save ? success_result : fail_result
  end

  private

  def category_params
    {
      name: category_name,
      financial_type: category_type
    }
  end

  def success_result
    {
      status: :ok,
      message: I18n.t("telegram.categories.new.was_added")
    }
  end

  def fail_result
    {
      status: :error,
      message: I18n.t("telegram.categories.new.please_check_category_name", error: get_error_message)
    }
  end

  def get_error_message
    if category_name.blank?
      I18n.t("telegram.categories.new.blank_name")
    else
      I18n.t("telegram.categories.new.existing_name_of_category")
    end
  end

  def parse_category_name(name)
    name.join(' ')
  end
end
