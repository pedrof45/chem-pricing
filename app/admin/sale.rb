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
	    column("UN") { |r| r.business_unit.code }
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
 		column :sale_date
	    column("Codigo Cliente") { |r| r.customer.code }
	    column("Nome Cliente") { |r| r.customer.name }
	    column("SKU") { |r| r.product.sku }
	    column("SKU") { |r| r.product.name }
	    column("CD") { |r| r.dist_center.name}
	    column("UN") { |r| r.business_unit.code }
	    column :moneda
	    column("Unidade") { |r| r.product.unit }
	    column :volume
	    column :base_price
	    column :unit_price
	    column :markup
	    column :comentario
	  end
end


#
