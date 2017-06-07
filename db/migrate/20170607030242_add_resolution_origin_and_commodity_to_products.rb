class AddResolutionOriginAndCommodityToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :resolution13, :boolean
    add_column :products, :origin, :integer
    add_column :products, :commodity, :boolean
  end
end
