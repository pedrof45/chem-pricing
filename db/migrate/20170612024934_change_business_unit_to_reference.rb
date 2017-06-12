class ChangeBusinessUnitToReference < ActiveRecord::Migration[5.1]
  def change
    remove_column :optimal_markups, :business_unit, :string
    remove_column :users, :business_unit, :string
    add_reference :optimal_markups, :business_unit
    add_reference :users, :business_unit
  end
end
