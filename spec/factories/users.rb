FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Fname #{n}" }
    sequence(:last_name)  { |n| "Lname #{n}" }
    sequence(:email)      { |n| "email.address#{n}@test-factory.com" }
    phone    "+188005553535"
    password "P@ssw0rd!"
  end
end
