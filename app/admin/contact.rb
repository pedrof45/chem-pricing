ActiveAdmin.register Contact do
  menu parent: '6. Companhia'
  permit_params :customer_id, :first_name, :last_name, :email, :position

  actions :all

  index do
    column :customer
    column :first_name
    column :last_name
    column :email
    column :position
    actions
  end

  form do |f|
    inputs do
      input :customer_id, as: :search_select, url: customers_path, fields: [:display_name], display_name: :display_name, minimum_input_length: 2
      input :first_name
      input :last_name
      input :email
      input :position
    end
    f.actions
  end
end
