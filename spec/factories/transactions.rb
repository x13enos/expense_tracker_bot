FactoryGirl.define do
  factory :transaction do
    association :user, factory: :user
    association :category, factory: [:category, :income]
    amount { Faker::Number.number(3) }
  end
end
