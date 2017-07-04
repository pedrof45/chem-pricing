ActiveAdmin.register NormalPackedFreight do
  menu parent: '4. Logistica'
  permit_params :origin, :destination, :category, :amount, :insurance, :gris, :toll, :ct_e, :min
  actions :all

  index do
    column :origin
    column :destination
    column :category
    column :amount
    column :insurance
    column :gris
    column :toll
    column :ct_e
    column :min 
    actions
  end

 csv do
    build_csv_columns(:normal_packed_freight).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :normal_packed_freight)
  end

  form do |f|
    f.inputs "Frete Embalado Normal" do
      f.input :origin
      f.input :destination
      f.input :category
      f.input :amount
      f.input :insurance
      f.input :gris
      f.input :toll 
      f.input :ct_e
      f.input :min  
    end
    f.actions
  end

end