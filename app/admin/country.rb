ActiveAdmin.register Country do
  menu parent: '7. Configuraçoes'
  permit_params :name, :code
  actions :all

  index do
    column :name
    column :code
    actions
  end
end

