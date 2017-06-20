ActiveAdmin.register BusinessUnit do
  permit_params :code, :name
  actions :all

  
  index do
    column :code
    column :name
    actions
  end
end