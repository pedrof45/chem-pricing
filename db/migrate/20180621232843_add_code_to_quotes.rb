class AddCodeToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :code, :string
  end
end
