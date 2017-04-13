FactoryGirl.define do
  factory :transaction do
    association :user, factory: :user
    association :category, factory: :category
  end
end
