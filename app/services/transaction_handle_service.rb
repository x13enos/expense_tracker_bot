class TransactionHandleService
  TRANSACTION_MESSAGE_REGEXP = /\A([^\d+]*)\s(-?\d+)\s?(.+)?/
  attr_accessor :transaction_data, :user

  def initialize(data, user)
    self.transaction_data = data["text"].match(TRANSACTION_MESSAGE_REGEXP)
    self.user = user
  end

  def perform
    if transaction.valid?
      transaction.save
      success_message
    else
      fail_message
    end
  end

  private

  def transaction
    @transaction ||= user.transactions.new(transaction_params)
  end

  def transaction_params
    {
      :category_id => category.try(:id),
      :amount => calculate_amount,
      :description => description
    }
  end

  def category
    @category ||= user.categories.find_by(:name => transaction_data[1])
  end

  def amount
    begin
      transaction_data[2].to_f.abs
    rescue
      nil
    end
  end

  def calculate_amount
    if category && amount
      category.financial_type == 'income' ? amount : -amount
    end
  end

  def description
    transaction_data[3]
  end

  def success_message
    I18n.t("telegram.transactions.transaction_was_added")
  end

  def fail_message
    I18n.t("telegram.transactions.transaction_was_not_added")
  end
end
