class AddCustomerFields < ActiveRecord::Migration[5.1]
  def change
    add_reference :customers, :country
    add_reference :customers, :city
    add_column :customers, :cnpj, :string
    add_column :customers, :contact, :string
  end
end
