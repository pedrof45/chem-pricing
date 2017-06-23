ActiveAdmin.register BusinessUnit do
menu parent: '6. Companhia'
  permit_params :code, :name
  actions :all
  
  index do
    column :code
    column :name
    actions
  end
end

