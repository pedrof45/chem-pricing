ActiveAdmin.register Vehicle do
  permit_params :name, :capacity
  actions :all

  index do
    column :name
    column :capacity
    actions
  end
end