ActiveAdmin.register NormalPackedFreight do
  menu parent: 'Tabelas Frete'
  permit_params :origin, :destination, :type, :amount, :insurance, :gris, :toll, :ct_e, :min
  actions :all

  index do
    column :origin
    column :destination
    column :type
    column :amount
    column :insurance
    column :gris
    column :toll
    column :ct_e
    column :min 
    actions
  end

  csv do
    column :origin
    column :destination
    column :type
    column :amount
    column :insurance
    column :gris
    column :toll
    column :ct_e
    column :min 
  end

end