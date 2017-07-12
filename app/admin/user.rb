ActiveAdmin.register User do
  menu label: 'Users', parent: '7. Configuraçoes', priority: 1
  permit_params :email, :password, :password_confirmation,
    :first_name, :last_name, :position, :business_unit_id, :role, :active

  index do
    column :email
    column 'Name', :full_name
    column :position
    column :role
    column("Unidade de Negocio") { |m| m.business_unit.code if m.business_unit }
    column :business_unit
    column :active
    actions
  end

  filter :email
  filter :full_name
  filter :position
  filter :role
  filter :business_unit
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :first_name
      f.input :last_name
      f.input :position
      f.input :business_unit
      f.input :role if current_user.sysadmin_or_more? 
      #&& !resource.role.sysadmin?
      f.input :active
    end
    f.actions
  end

end
