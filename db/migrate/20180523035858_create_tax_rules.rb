class CreateTaxRules < ActiveRecord::Migration[5.1]
  def change
    create_table :tax_rules do |t|
      t.string :tax_type
      t.references :customer, foreign_key: true
      t.references :product, foreign_key: true
      t.string :origin
      t.string :destination
      t.decimal :value

      t.timestamps
    end
  end
end
