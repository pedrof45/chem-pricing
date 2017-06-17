class AddFieldsToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_reference :quotes, :optimal_markup
    add_reference :quotes, :cost
    add_column :quotes, :fob_net_price, :decimal
    add_column :quotes, :freight_table, :integer
    add_column :quotes, :final_freight, :decimal
    add_column :quotes, :comment, :string
    add_column :quotes, :unit_freight, :decimal
  end
end
