ActiveAdmin.register_page 'Simulator' do
  menu priority: 1
 content title: 'Simulador de Preço' do
   @quote = Quote.new
   render partial: 'base', locals: { quote: @quote }
 end
end