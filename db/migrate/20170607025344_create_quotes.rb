class CreateQuotes < ActiveRecord::Migration[5.1]
  def change
    create_table :quotes do |t|
      t.references :user, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :product, foreign_key: true
      t.datetime :quote_date
      t.string :payment_term
      t.boolean :icms_padrao
      t.decimal :icms
      t.decimal :ipi
      t.boolean :pis_confins_padrao
      t.decimal :pis_confins
      t.string :freight_condition
      t.decimal :brl_usd
      t.decimal :brl_eur
      t.decimal :quantity
      t.string :unit
      t.decimal :unit_price
      t.decimal :markup
      t.boolean :fixed_price

      t.timestamps
    end
  end
end
