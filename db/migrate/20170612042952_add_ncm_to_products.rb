class AddNcmToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :ncm, :string
  end
end
