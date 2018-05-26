FactoryGirl.define do
  factory :category do
    association :user, factory: :user
    name { Faker::Lorem.unique.word }
    financial_type "income"
  end

  trait :income do
    financial_type "income"
  end

  trait :expense do
    financial_type "expense"
  end

end
