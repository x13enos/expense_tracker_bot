json.expense         @transactions.by_financial_type("expense").sum(:amount)
json.income          @transactions.by_financial_type("income").sum(:amount)
json.current_month   Time.now.strftime("%B")
json.transactions    @transactions.return_last(10) do |transaction|
  json.category      transaction.category.name
  json.isExpense     transaction.category.expense?
  json.amount        transaction.amount
  json.date          transaction.created_at.strftime("%d %B %Y - %T")
end
