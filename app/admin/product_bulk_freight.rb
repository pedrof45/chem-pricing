ActiveAdmin.register ProductBulkFreight do
  menu parent: '4. Logistica'
  permit_params :origin, :destination, :vehicle_id, :amount, :product_id ,:toll
  actions :all

  index do
    column :origin
    column :destination
    column("Tp Veic") { |r| r.vehicle.name }
    column("Produto") { |r| r.product.sku }
    column :amount
    column :toll
    actions
  end

  csv do
    build_csv_columns(:product_bulk_freight).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :product_bulk_freight)
  end

end