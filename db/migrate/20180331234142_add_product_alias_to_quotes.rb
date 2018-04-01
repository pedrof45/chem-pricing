class AddProductAliasToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :product_alias, :string
  end
end
