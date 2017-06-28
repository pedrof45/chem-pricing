ActiveAdmin.register Customer do
  menu parent: '6. Companhia'
  permit_params :code, :name, :email, :city_id, :cnpj, :contact, :country_id
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


  filter :name
  filter :code
  filter :cnpj
  filter :country
  filter :state
  filter :city

  csv do
    column :id
    column :name
    column :code
    column :cnpj
    column("Pais") { |r| r.country.name }
    column("Estado") { |r| r.city.try :state }
    column("Cidade") { |r| r.city.name }
    column :contact
    column :email

  end


end


