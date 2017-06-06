ActiveAdmin.register Customer do
  permit_params :code, :name, :email
end
