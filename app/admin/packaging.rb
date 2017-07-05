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

csv do
    build_csv_columns(:packaging).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :packaging)
  end

end