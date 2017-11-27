FactoryGirl.define do
  factory :email do
    user
    customer
    recipient 'contact@example.com'
    subject "MyString"
    message "MyString"
  end
end
