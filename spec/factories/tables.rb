FactoryGirl.define do
  factory :table do
    sequence(:name) { |n| "Table #{n}" }
  end
end
