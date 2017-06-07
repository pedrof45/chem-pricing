class CreateCosts < ActiveRecord::Migration[5.1]
  def change
    create_table :costs do |t|
      t.references :product, foreign_key: true
      t.references :dist_center, foreign_key: true
      t.decimal :base_price
      t.string :currency
      t.decimal :suggested_markup

      t.timestamps
    end
  end
end
