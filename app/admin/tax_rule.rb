ActiveAdmin.register TaxRule do
  menu parent: '5. Financeiro'

  permit_params :customer_id, :product_id, :value, :origin, :destination, :tax_type

  actions :all


end
