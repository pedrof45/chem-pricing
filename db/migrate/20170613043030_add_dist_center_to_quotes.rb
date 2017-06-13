class AddDistCenterToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_reference :quotes, :dist_center
  end
end
