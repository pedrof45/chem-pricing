class CreateNormalBulkFreights < ActiveRecord::Migration[5.1]
  def change
    create_table :normal_bulk_freights do |t|
      t.string :origin
      t.string :destination
      t.references :vehicle, foreign_key: true
      t.decimal :amount
      t.decimal :toll

      t.timestamps
    end
  end
end
