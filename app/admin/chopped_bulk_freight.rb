ActiveAdmin.register ChoppedBulkFreight do
  menu parent: '4. Logistica'
  permit_params :operation, :amount
  actions :all

  index do
    column :operation
    column :amount
    actions
  end

  csv do
    build_csv_columns(:chopped_bulk_freight).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :chopped_bulk_freight)
  end

end

