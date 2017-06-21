class RemovePaymentTermFromQuote < ActiveRecord::Migration[5.1]
  def change
    remove_column :quotes, :payment_term, :string
  end
end
