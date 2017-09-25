require 'rails_helper'

RSpec.describe Quote, type: :model do

  let!(:sv1) { create(:system_variable, name: 'interest_2_30', value: 0.02) }
  let!(:sv2) { create(:system_variable, name: 'interest_31_60', value: 0.025) }

  # customers
  ['1000023036',
   '1000028348',
   '1000024466',
   '1000006275',
   '1000023644',
   '1000030095',
   '1000015023',
   '1000014407'].each_with_index do |cust_code, i|
    let!("c_#{i}") { create(:customer, code: cust_code) }
  end

  # products
  {'64320022-93' => 1,
   '81510094-10' => 1,
   '35410018-1' => 1,
   '66740043-10' => 1,
   '66740040-10' => 1,
   '51010004-482' => 0.785,
   '57010102-482' => 0.67,
   '52060110-116' => 0.95,
   '52050002-10' => 1.044604617 }.each_with_index do |(sku_code, density), i|
    let!("p_#{i}") { create(:product, sku: sku_code, density: density) }
  end

  # dist centers
  let!(:SP12) { create(:dist_center, code: 'SP12') }
  let!(:SP13) { create(:dist_center, code: 'SP13') }
  let!(:NN) { create(:dist_center, code: 'NN') }

  # costs
  CSV.foreach("spec/costs.csv", headers: true) do |row|
    let!("cost_#{$. - 1}") do
      params = row.to_h.except('product_sku', 'dist_center_code')
      product = Product.find_by!(sku: row['product_sku'])
      dc = DistCenter.find_by!(code: row['dist_center_code']) # unless row['dist_center_code'] == 'nil'
      params.merge!(product: product, dist_center: dc)
      create(:cost, params)
    end
  end

  # optimal markups
  CSV.foreach("spec/optimal_markups.csv", headers: true) do |row|
    let!("om_#{$. - 1}") do
      params = row.to_h.except('customer_code', 'product_sku', 'dist_center_code', nil)
      customer = Customer.find_by!(code: row['customer_code'])
      product = Product.find_by!(sku: row['product_sku'])
      dc = DistCenter.find_by!(code: row['dist_center_code']) # unless row['dist_center_code'] == 'nil'
      params.merge!(customer: customer, product: product, dist_center: dc, table_value: row['value'])
      create(:optimal_markup, params)
    end
  end

    # quotes
    QUOTE_EXPECTED_PRICES = {}
    CSV.foreach("spec/quotes.csv", headers: true) do |row|
      let!("q_#{$. - 1}") do
        params = row.to_h.reject { |k,v| k.starts_with?('n_') }
        customer = Customer.find_by!(code: row['customer_code'])
        product = Product.find_by!(sku: row['product_sku'])
        dc = DistCenter.find_by!(code: row['dist_center_code']) # unless row['dist_center_code'] == 'nil'
        params.except!('customer_code', 'product_sku', 'dist_center_code', nil)
        params.merge!(customer: customer, product: product, dist_center: dc, fixed_price: false, freight_padrao: false)
        quote = create(:quote, params)
        QUOTE_EXPECTED_PRICES[quote]  = row['n_output_unit_price']
        quote
      end
    end

  context 'with the quote list' do

    18.times do |i|
      it "quotes correctly quote ##{i + 1}" do
        quote = send("q_#{i + 1}")
        puts "Quote ##{i + 1} result #{quote.unit_price}, expected #{QUOTE_EXPECTED_PRICES[quote].to_f}"
        expect(quote.unit_price).to be_within(0.05).of(QUOTE_EXPECTED_PRICES[quote].to_f)
      end
    end
  end


end
