ActiveAdmin.register OptimalMarkup do
  menu label: '2. Markups', priority: 3
  permit_params :customer_id, :product_id, :dist_center_id, :value, :business_unit_id, :table_value
  actions :all

  index title: 'Markups por Cliente e Produto' do
    column("Codigo Cliente") { |m| m.customer.code if m.customer }
    column("Nome Cliente") { |m| m.customer.name if m.customer}
    column("SKU") { |m| m.product.sku }
    column("Nome Produto") { |m| m.product.name }
    column("Unidade Negocio") { |m| m.business_unit.code if m.business_unit }
    column("CD Origem") { |m| m.dist_center.code }
    column :value
    column :table_value
    actions
  end

  csv do
    build_csv_columns(:optimal_markup).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :optimal_markup)
  end
end
