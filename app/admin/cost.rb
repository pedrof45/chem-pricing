ActiveAdmin.register Cost do
  menu label: 'Preços Piso', parent: '3. Produtos'
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
    column :amount_for_price
    column("Preço Piso") { |r| r.base_price.round(2) }
    column :suggested_markup
    column :updated_cost
    column :on_demand
    actions
  end

  csv do
    build_csv_columns(:cost).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :cost)
  end


end


