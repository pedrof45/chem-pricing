class RemoveUnitFromCost < ActiveRecord::Migration[5.1]
  def change
    remove_column :costs, :unit, :string
  end
end
