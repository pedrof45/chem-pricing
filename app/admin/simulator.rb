ActiveAdmin.register_page 'Simulator' do
  menu priority: 1
 content title: 'Simulador de Preço' do
   @quote = Quote.new(customer: Customer.take, product: Product.take, unit_price: 77)
   render partial: 'base', locals: { quote: @quote }
 end
end