class CreateIcmsTaxes < ActiveRecord::Migration[5.1]
  def change
    create_table :icms_taxes do |t|
      t.string :origin
      t.string :destination
      t.decimal :value

      t.timestamps
    end
  end
end
