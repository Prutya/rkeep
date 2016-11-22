FactoryGirl.define do
  factory :spending do
    sequence(:name) { |n| "Spenging #{n}" }
    total "100.01"
  end
end
