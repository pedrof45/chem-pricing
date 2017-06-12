ActiveAdmin.register Cost do
  menu label: 'Preços Piso'
  permit_params :product_id, :dist_center_id, :base_price, :currency,
    :suggested_markup, :unit, :amount_for_price, :updated_cost,
    :last_month_base_price, :last_month_fob_net, :product_analyst,
    :lead_time, :min_order_quantity, :frac_emb, :source_adjustment,
    :competition_adjustment, :commentary

  actions :all

  index title: 'Preço Piso por Produto e CD' do
    column("CD") { |r| r.dist_center.code }
    column("SKU") { |r| r.product.sku }
    column("Nome Produto") { |r| r.product.name }
    column("UN") { |r| r.product.unit }
    column :amount_for_price
    column :currency
    column("Preço Piso") { |r| r.base_price }
    column :suggested_markup
    column :unit
    column :amount_for_price
    column :updated_cost
    actions
  end
end
