json.transactions    @transactions do |transaction|
  json.id            transaction.id
  json.amount        transaction.amount
  json.date          transaction.created_at.strftime("%d %B %Y - %T")
  json.category_id   transaction.category.id
  json.category_name transaction.category.name
  json.isExpense     transaction.category.expense?
end
json.categories    @categories do |category|
  json.id            category.id
  json.name          category.name
end
