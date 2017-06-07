FactoryGirl.define do
  factory :quote do
    user nil
    customer nil
    product nil
    quote_date "2017-06-06 22:53:44"
    payment_term "MyString"
    icms_padrao false
    icms "9.99"
    ipi "9.99"
    pis_confins_padrao false
    pis_confins "9.99"
    freight_condition "MyString"
    brl_usd "9.99"
    brl_eur "9.99"
    quantity "9.99"
    unit "MyString"
    unit_price "9.99"
    markup "9.99"
    fixed_price false
  end
end
