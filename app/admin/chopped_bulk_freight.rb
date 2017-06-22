ActiveAdmin.register ChoppedBulkFreight do
  menu parent: 'Tabelas Frete'
  permit_params :operation, :amount
  actions :all

  index do
    column :operation
    column :amount
    actions
  end
end