class Api::V1::TransactionsController < Api::V1::BaseController

  def index
    @transactions = current_user.transactions
    @categories = current_user.categories
  end

  def update
    @transaction = current_user.transactions.find(params[:id])
    if @transaction.update(transaction_params)
      render "update"
    else
      render json: { errors: @transaction.errors.full_messages }, status: 400
    end
  end

  private

  def transaction_params
    params.permit(:amount, :category_id)
  end
end
