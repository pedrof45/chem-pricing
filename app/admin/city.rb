ActiveAdmin.register City do
  permit_params :id, :name, :code
  actions :all

  index do
    column :name
    column :state
    column :code
    actions
  end


end
