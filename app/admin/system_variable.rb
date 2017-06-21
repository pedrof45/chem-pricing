ActiveAdmin.register SystemVariable do
  permit_params :name, :value
  actions :index, :edit, :update

  index do
    column :name
    column :value
    actions
  end
end