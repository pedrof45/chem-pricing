class AddFieldToOptimalMarkup < ActiveRecord::Migration[5.1]
  def change
  	add_column :optimal_markups, :metodology, :string
  end
end
