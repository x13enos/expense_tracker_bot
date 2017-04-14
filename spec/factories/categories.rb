FactoryGirl.define do
  factory :category do
    association :user, factory: :user
  end

  trait :income do
    name "Salary"
    financial_type "income"
  end

  trait :expense do
    name "Food"
    financial_type "expense_category"
  end

end
