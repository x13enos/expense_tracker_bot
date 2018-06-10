json.id            @transaction.id
json.amount        @transaction.amount
json.date          @transaction.created_at.strftime("%d %B %Y - %T")
json.category_id   @transaction.category.id
json.category_name @transaction.category.name
json.isExpense     @transaction.category.expense?
