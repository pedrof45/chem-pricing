class CreateSpecialPackedFreights < ActiveRecord::Migration[5.1]
  def change
    create_table :special_packed_freights do |t|
      t.string :origin
      t.string :destination
      t.string :type
      t.decimal :amount
      t.decimal :insurance
      t.decimal :gris
      t.decimal :toll
      t.decimal :ct_e
      t.decimal :min

      t.timestamps
    end
  end
end
