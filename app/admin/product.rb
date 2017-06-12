ActiveAdmin.register Product do
  permit_params :sku, :name, :unit, :currency, :ipi,
    :density, :resolution13, :origin, :commodity

  actions :all

  index do
    column :sku
    column :name
    column :ncm
    column :unit
    column :density
    column :ipi
    column :resolucion13
    column :origin
  end



end
