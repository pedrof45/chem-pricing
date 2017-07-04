ActiveAdmin.register City do
  menu parent: '7. Configuraçoes'
  permit_params :id, :name, :code
  actions :all

  index do
    column :name
    column :state
    column :code
    actions
  end

  csv do
    build_csv_columns(:city).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :city)
  end
end

