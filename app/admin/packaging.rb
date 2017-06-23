ActiveAdmin.register Packaging do
  menu parent: '4. Logistica', priority: 100
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