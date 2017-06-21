class CreateChoppedBulkFreights < ActiveRecord::Migration[5.1]
  def change
    create_table :chopped_bulk_freights do |t|
      t.string :operation
      t.decimal :amount

      t.timestamps
    end
  end
end
