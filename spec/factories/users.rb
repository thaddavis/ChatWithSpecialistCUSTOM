FactoryGirl.define do
  factory :user do
    email "john@example.com"
    password "secret"
    first_name "John"
    last_name "Doe"
    confirmed_at DateTime.now
  end
end
