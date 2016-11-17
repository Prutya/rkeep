FactoryGirl.define do
  factory :good do
    sequence(:name) { |n| "Good #{n}" }
    price 100.01
  end
end
