ActiveAdmin.register NormalPackedFreight do
  menu parent: '4. Logistica'
  permit_params :origin, :destination, :category, :amount, :insurance, :gris, :toll, :ct_e, :min
  actions :all

  index do
    column :origin
    column :destination
    column :category
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
    column :category
    column :amount
    column :insurance
    column :gris
    column :toll
    column :ct_e
    column :min 
  end

end