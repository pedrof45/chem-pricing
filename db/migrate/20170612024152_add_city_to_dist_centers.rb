class AddCityToDistCenters < ActiveRecord::Migration[5.1]
  def change
    add_reference :dist_centers, :city
  end
end
