ActiveAdmin.register Product do
  permit_params :sku, :name, :ncm, :unit, :currency, :ipi, :density, :resolution13, :origin, :commodity

  actions :all

  index do
    column :sku
    column :name
    column :ncm
    column :unit
    column :density
    column :ipi
    column :resolution13
    column :origin
    actions
  end

  filter :sku
  filter :name
  filter :unit
  filter :density
  filter :ipi
  filter :resolucion13

  csv do
    column :sku
    column :name
    column :ncm
    column :unit
    column :density
    column :ipi
    column :resolution13
    column :origin
  end
end
