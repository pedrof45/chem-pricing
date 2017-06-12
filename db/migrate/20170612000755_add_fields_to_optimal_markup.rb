class AddFieldsToOptimalMarkup < ActiveRecord::Migration[5.1]
  def change
    add_column :optimal_markups, :business_unit, :string
    add_column :optimal_markups, :table_value, :decimal
  end
end
