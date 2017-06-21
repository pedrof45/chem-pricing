class RemoveFieldsFromProduct < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :currency, :string
    remove_column :products, :commodity, :boolean
  end
end
