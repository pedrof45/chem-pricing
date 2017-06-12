ActiveAdmin.register DistCenter do
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
