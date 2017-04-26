class TransactionsListService
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def perform
    if transactions.any?
      build_transactions_list
    else
      I18n.t('telegram.transactions_list.you_do_not_have_transactions')
    end
  end

  private

  def build_transactions_list
    groupped_list = transactions.group_by{ |t| parse_date(t.created_at) }
    groupped_list.map{|date, transactions| date_with_transactions(date, transactions)}.join("\n\n")
  end

  def date_with_transactions(date, transactions)
    ([date] + transactions.map{|t| transaction_output(t) }).join("\n")
  end

  def parse_date(date)
    "*#{date.strftime("%a, %-d %B %Y")}*"
  end

  def transactions
    @transactions ||= user.transactions.joins(:category).current_month.order("created_at DESC").limit(20)
  end

  def transaction_output(transaction)
    "#{ transaction.description || transaction.category.name }:  #{transaction.amount}"
  end
end
