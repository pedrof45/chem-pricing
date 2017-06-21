class CreateNormalPackedFreights < ActiveRecord::Migration[5.1]
  def change
    create_table :normal_packed_freights do |t|
      t.string :origin
      t.string :destination
      t.references :vehicle, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
