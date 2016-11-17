FactoryGirl.define do
  factory :bill do
    discount 0.00
    time_open Time.zone.now
  end
end
