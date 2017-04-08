FactoryGirl.define do
  factory :category do
  end

  factory :income_category do
    name "Salary"
    financial_type "income"
  end

  factory :expense_category do
    name "Food"
    financial_type "expense_category"
  end

end
