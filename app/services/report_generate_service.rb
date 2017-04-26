class ReportGenerateService
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def perform
    if transactions.any?
      build_transactions_list
    else
      I18n.t('telegram.reports.you_do_not_have_transactions')
    end
  end

  private

  def build_transactions_list
    [group_by_month, group_by_day].join("\n\n")
  end

  def group_by_month
    [I18n.t("telegram.reports.group_by_month"), amounts_gropped_by_month.map{|c, a| category_amount(c, a)}].join("\n")
  end

  def group_by_day
    [I18n.t("telegram.reports.group_by_day"), amounts_gropped_by_day.map{|c, a| category_and_day_amount(c, a)}].join("\n")
  end

  def parse_date(date)
    "*#{date.strftime("%a, %-d %B %Y")}*"
  end

  def transactions
    @transactions ||= user.transactions.joins(:category).current_month
  end

  def amounts_gropped_by_month
    transactions.group("categories.name").sum(:amount)
  end

  def category_amount(category_name, amount)
    "#{category_name}: #{amount}"
  end

  def amounts_gropped_by_day
    transactions.group("categories.name").group('transactions.created_at::date').sum(:amount)
  end

  def category_and_day_amount(category_and_date, amount)
    category_name, date = category_and_date
    category_output = category_amount(category_name, amount)
    the_same_date = @last_date == date
    @last_date = date
    the_same_date ? category_output : [parse_date(date), category_output].join("\n")
  end
end
