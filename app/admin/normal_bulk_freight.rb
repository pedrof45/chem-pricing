ActiveAdmin.register NormalBulkFreight do
  menu parent: 'Tabelas Frete'
  permit_params :origin, :destination, :vehicle_id, :amount, :toll
  actions :all

  index do
    column :origin
    column :destination
    column("Tp Veic") { |r| r.vehicle.name }
    column :amount
    column :toll
    actions
  end
end