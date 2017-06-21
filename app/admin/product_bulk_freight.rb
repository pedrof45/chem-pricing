ActiveAdmin.register ProductBulkFreight do
  menu parent: 'Tabelas Frete'
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
    column :origin
    column :destination
    column("Tp Veic") { |r| r.vehicle.name }
    column("Produto") { |r| r.product.sku }
    column :amount
    column :toll
  end

end