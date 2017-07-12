ActiveAdmin.register Sale do
	menu label: '8. Histórico de Vendas'
	permit_params :sale_date, :customer_id, :product_id, :dist_center_id, :business_unit_id, :moneda, :volume, :base_price, 
	:unit_price,:markup,:comentario
	  actions :all

	  index do
	    column :sale_date
	    column("Codigo Cliente") { |r| r.customer.code }
	    column("Nome Cliente") { |r| r.customer.name }
	    column("SKU") { |r| r.product.sku }
	    column("SKU") { |r| r.product.name }
	    column("CD") { |r| r.dist_center.name}
	    column("UN") { |r| r.business_unit.code if r.business_unit}
	    column :moneda
	    column("Unidade") { |r| r.product.unit }
	    column :volume
	    column :base_price
	    column :unit_price
	    column :markup
	    column :comentario
	    actions
	  end

 csv do
    build_csv_columns(:sale).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Upload Tabela', new_upload_path(model: :sale)
  end
end


#
