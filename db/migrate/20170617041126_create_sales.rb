class CreateSales < ActiveRecord::Migration[5.1]
  def change
    create_table :sales do |t|
      t.datetime :sale_date
      t.references :customer, foreign_key: true
      t.references :product, foreign_key: true
      t.references :dist_center, foreign_key: true
      t.references :user
      t.references :business_unit, foreign_key: true
      t.string :moneda
      t.string :unit
      t.decimal :volume
      t.decimal :base_price
      t.decimal :unit_price
      t.string :calculated
      t.decimal :markup
      t.string :comentario

      t.timestamps
    end
  end
end
