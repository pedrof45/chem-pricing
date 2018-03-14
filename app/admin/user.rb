ActiveAdmin.register User do
  menu label: 'Users', parent: '7. Configuraçoes', priority: 1
  permit_params :email, :password, :password_confirmation,
    :first_name, :last_name, :position, :business_unit_id, :role, :active, :supervisor_id

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

  show do
    attributes_table do
      row :email
      row :last_sign_in_at
      row :last_sign_in_ip
      row :name
      row :last_name
      row :position
      row :role
      row :active
      row :business_unit
      row :supervisor
    end

    panel 'É o Apoio dos seguintes vendedores:', style: 'max-width: 500px;' do
      supervised = resource.supervised
      if supervised.empty?
        span 'Nehum'
      else
        table_for(supervised) do
          column :id
          column('Nome') { |s_u| link_to s_u.full_name, user_path(s_u) }
          column :email
          column :position
        end
      end
    end
  end


  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password if current_user.sysadmin_or_more? || resource == current_user
      f.input :password_confirmation if current_user.sysadmin_or_more? || resource == current_user
      f.input :first_name
      f.input :last_name
      f.input :position
      f.input :business_unit
      f.input :role if current_user.sysadmin_or_more? 
      #&& !resource.role.sysadmin?
      f.input :supervisor unless resource.manager_or_more?
      f.input :active
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end
end
