class CreateDistCenters < ActiveRecord::Migration[5.1]
  def change
    create_table :dist_centers do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
