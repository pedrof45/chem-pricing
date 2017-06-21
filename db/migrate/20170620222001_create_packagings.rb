class CreatePackagings < ActiveRecord::Migration[5.1]
  def change
    create_table :packagings do |t|
      t.integer :code
      t.string :name
      t.decimal :capacity
      t.decimal :weight

      t.timestamps
    end
  end
end
