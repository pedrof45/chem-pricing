ActiveAdmin.register Cost do
  menu label: 'Preços Piso'
  permit_params :product_id, :dist_center_id, :base_price,
      :currency, :suggested_markup
  actions :all

  index title: 'Preço Piso por Produto e CD' do
    column("CD") { |r| r.dist_center.code }
    column("SKU") { |r| r.product.sku }
    column("Nome Produto") { |r| r.product.name }
    column("UN") { |r| r.product.unit }
    column("Moeda") { |r| r.currency }
    column("Preço Piso") { |r| r.base_price }
    column("MSP%") { |r| r.suggested_markup }
  end
end
