class CreateOptimalMarkups < ActiveRecord::Migration[5.1]
  def change
    create_table :optimal_markups do |t|
      t.references :product, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :dist_center, foreign_key: true
      t.decimal :value

      t.timestamps
    end
  end
end
