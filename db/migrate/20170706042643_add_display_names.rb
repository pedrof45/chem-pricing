class AddDisplayNames < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :display_name, :string
    add_column :customers, :display_name, :string
  end
end
