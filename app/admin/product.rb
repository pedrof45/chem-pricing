ActiveAdmin.register Product do
  permit_params :sku, :name, :unit, :currency, :ipi,
    :density, :resolution13, :origin, :commodity
end
