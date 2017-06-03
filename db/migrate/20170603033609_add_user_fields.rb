class AddUserFields < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :position, :string
    add_column :users, :business_unit, :string
    add_column :users, :role, :string
    add_column :users, :active, :boolean
  end
end
