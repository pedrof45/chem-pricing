class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :name
      t.string :unit
      t.string :currency
      t.decimal :ipi

      t.timestamps
    end
  end
end
