ActiveAdmin.register OptimalMarkup do
  menu label: 'Markups'
  permit_params :customer_id, :product_id, :dist_center_id, :value
  actions :all

  index title: 'Markups por Cliente e Produto' do
    column("Nome Cliente") { |m| m.customer.name }
    column("Codigo Cliente") { |m| m.customer.code }
    column("Producto") { |m| m.product.name }
    column("SKU") { |m| m.product.sku }
    column("UN") { |m| m.product.unit }
    column("CD de Origem") { |m| m.dist_center.code }
    column("Mark-Up") { |m| m.value }
  end
end
