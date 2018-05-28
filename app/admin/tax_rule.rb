ActiveAdmin.register TaxRule do
  menu parent: '5. Financeiro'

  permit_params :customer_id, :product_id, :value, :origin, :destination, :tax_type

  actions :all

  csv do
    build_csv_columns(:tax_rule).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :tax_rule)
  end

end
