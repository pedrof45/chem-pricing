class AddVehicleToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_reference :quotes, :vehicle
  end
end
