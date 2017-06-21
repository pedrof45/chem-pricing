class AddOnDemandToCost < ActiveRecord::Migration[5.1]
  def change
    add_column :costs, :on_demand, :string
  end
end
