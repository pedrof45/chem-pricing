class AddActiveToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :active, :boolean, default: true
  end
end
