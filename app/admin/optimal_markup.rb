ActiveAdmin.register OptimalMarkup do
  menu label: 'Markups'
  permit_params :customer_id, :product_id, :dist_center_id, :value, :business_unit_id, :table_value
  actions :all

  index title: 'Markups por Cliente e Produto' do
    column("Codigo Cliente") { |m| m.customer.code }
    column("Nome Cliente") { |m| m.customer.name }
    column("SKU") { |m| m.product.sku }
    column("Nome Produto") { |m| m.product.name }
    column("Unidade Negocio") { |m| m.business_unit.code if m.business_unit }
    column("CD Origem") { |m| m.dist_center.code }
    column :value
    column :table_value
    actions
  end

  csv do
    column :id
    column("Codigo Cliente") { |m| m.customer.code }
    column("Nome Cliente") { |m| m.customer.name }
    column("SKU") { |m| m.product.sku }
    column("Nome Produto") { |m| m.product.name }
    column("Unidade Negocio") { |m| m.business_unit.code if m.business_unit }
    column("CD Origem") { |m| m.dist_center.code }
    column :table_value
    column :value
  end
end
