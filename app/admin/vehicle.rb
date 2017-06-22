ActiveAdmin.register Vehicle do
  menu parent: '4. Logistica', priority: 99
  permit_params :name, :capacity
  actions :all

  index do
    column :name
    column :capacity
    actions
  end
end