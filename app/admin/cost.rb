ActiveAdmin.register Cost do
  menu label: 'Preços Piso'
  permit_params :product_id, :dist_center_id, :base_price, :currency,
    :suggested_markup, :amount_for_price, :updated_cost,
    :last_month_base_price, :last_month_fob_net, :product_analyst,
    :lead_time, :min_order_quantity, :frac_emb, :source_adjustment,
    :competition_adjustment, :commentary, :on_demand

  actions :all

  index title: 'Preço Piso por Produto e CD' do
    column("CD") { |r| r.dist_center.code }
    column("SKU") { |r| r.product.sku }
    column("Nome Produto") { |r| r.product.name }
    column :currency
    column("Unidade") { |r| r.product.unit }
    column :amount_for_price
    column("Preço Piso") { |r| r.base_price }
    column :suggested_markup
    column :updated_cost
    column :on_demand
    actions
  end

  csv do
    column("CD") { |r| r.dist_center.code }
    column("SKU") { |r| r.product.sku }
    column("Nome Produto") { |r| r.product.name }
    column :currency
    column("Unidade") { |r| r.product.unit }
    column :amount_for_price
    column("Preço Piso") { |r| r.base_price }
    column :suggested_markup
    column :updated_cost
    column :last_month_base_price
    column :last_month_fob_net
    column :product_analyst
    column :on_demand
    column :lead_time
    column :min_order_quantity
    column :frac_emb
    column :source_adjustment
    column :competition_adjustment
    column :commentary
  end


end


