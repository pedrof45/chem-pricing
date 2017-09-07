class AddCurrencyToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :currency, :string
  end
end
