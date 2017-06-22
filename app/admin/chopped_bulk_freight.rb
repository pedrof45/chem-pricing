ActiveAdmin.register ChoppedBulkFreight do
  menu parent: '4. Logistica'
  permit_params :operation, :amount
  actions :all

  index do
    column :operation
    column :amount
    actions
  end

  csv do
  	column :operation
    column :amount
  end

end

