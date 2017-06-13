class AddCityToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_reference :quotes, :city
  end
end
