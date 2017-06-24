class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.string :filename
      t.string :model
      t.references :user


      t.timestamps
    end
  end
end
