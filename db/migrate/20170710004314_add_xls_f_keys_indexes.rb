class AddXlsFKeysIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index(:dist_centers, :code)
    add_index(:products, :sku)
    add_index(:countries, :code)
    add_index(:vehicles, :name)
    add_index(:customers, :code)
    add_index(:business_units, :code)
    add_index(:cities, :code)
  end
end
