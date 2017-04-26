FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    telegram_id { Faker::Number.number(8) }
  end
end
