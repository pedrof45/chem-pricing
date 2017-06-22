ActiveAdmin.register SystemVariable do
 menu parent: '5. Financeiro'
  permit_params :name, :value
  actions :index, :edit, :update

  index do
    column :name
    column :value
    actions
  end
end