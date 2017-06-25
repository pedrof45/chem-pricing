ActiveAdmin.register NormalPackedFreight do
  menu parent: '4. Logistica'
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

  form do |f|
    f.inputs "User Details" do
      f.input :origin
      f.input :destination
      f.input :type
      f.input :amount
      f.input :insurance
      f.input :gris
      f.input :toll 
      f.input :ct_e
      f.input :min  
    end
    f.actions
  end

end