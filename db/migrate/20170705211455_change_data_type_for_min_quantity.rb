class ChangeDataTypeForMinQuantity < ActiveRecord::Migration[5.1]
  def change
  	remove_column :costs ,:min_order_quantity, :decimal
  	add_column :costs, :min_order_quantity, :string
  end
end
