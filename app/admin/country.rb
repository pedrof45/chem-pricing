ActiveAdmin.register Country do
  permit_params :name, :code
  actions :all

  index do
    column :name
    column :code
    actions
  end
end