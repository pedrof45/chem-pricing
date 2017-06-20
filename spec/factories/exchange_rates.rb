FactoryGirl.define do
  factory :exchange_rate do
    from "MyString"
    to "MyString"
    rate_date "2017-06-20"
    value 1.14
  end
end
