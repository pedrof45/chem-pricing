ActiveAdmin.register DistCenter do
  menu parent: '4. Logistica', priority: 98
  permit_params :code, :name, :city_id
  actions :all

  
  index do
    column :code
    column :name
    column :city
    column("UF") { |dc| dc.city.try :state }
    actions
  end
end

