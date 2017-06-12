ActiveAdmin.register Customer do
  permit_params :code, :name, :email
  actions :all

  index do
    column :name
    column :code
    column :cnpj
    column :country
    column("Estado") { |r| r.city.try :state }
    column :city
    column :contact
    column :email
    actions
  end
end
