ActiveAdmin.register Vehicle do
  menu parent: '4. Logistica', priority: 99
  permit_params :name, :capacity
  actions :all

  index do
    column :name
    column :capacity
    actions
  end

  csv do
    build_csv_columns(:vehicle).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :vehicle)
  end
end