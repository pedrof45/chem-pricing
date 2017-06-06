ActiveAdmin.register Product do
  permit_params :sku, :name, :unit, :currency, :ipi, :density
end
