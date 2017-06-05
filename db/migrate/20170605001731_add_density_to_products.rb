class AddDensityToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :density, :decimal
  end
end
