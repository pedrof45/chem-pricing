class AddPaymentTermDescriptionToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :payment_term_description, :string
  end
end
