class Api::V1::TransactionsController < Api::V1::BaseController

  def index
    transaction_searcher = TransactionsSearchQuery.new(current_user.transactions, params[:search])
    @transactions = transaction_searcher.all.
                    order(created_at: :desc).
                    paginate(params["page"])
    @categories = current_user.categories
  end

  def create
    @transaction = current_user.transactions.new(transaction_params)
    if @transaction.save
      render "transaction"
    else
      render json: { errors: @transaction.errors.full_messages }, status: 400
    end
  end

  def update
    @transaction = current_user.transactions.find(params[:id])
    if @transaction.update(transaction_params)
      render "transaction"
    else
      render json: { errors: @transaction.errors.full_messages }, status: 400
    end
  end

  private

  def transaction_params
    params[:transaction].permit(:amount, :category_id)
  end
end
