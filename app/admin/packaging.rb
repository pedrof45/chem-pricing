ActiveAdmin.register Packaging do
  permit_params :code, :name, :capacity, :weight
  actions :all

  index do
    column :code
    column :name
    column :capacity
    column :weight
    actions
  end
end