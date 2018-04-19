class Api::V1::DashboardController < Api::V1::BaseController

  def index
    @transactions = current_user.transactions.current_month
  end

end
