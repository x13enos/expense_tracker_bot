class BalanceCalculateService
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def perform
    I18n.t('telegram.balance.you_have', :balance => balance)
  end

  private

  def balance
    user.transactions.sum(:amount).to_i
  end
end
