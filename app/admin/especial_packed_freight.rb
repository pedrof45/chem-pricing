ActiveAdmin.register EspecialPackedFreight do
  menu parent: 'Tabelas Frete'
  permit_params :origin, :destination, :vehicle_id, :amount
  actions :all

  index do
    column :origin
    column :destination
    column("Tp Veic") { |r| r.vehicle.name }
    column :amount
    actions
  end
end