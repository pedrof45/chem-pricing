class AddFreightFieldsToQuote < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :freight_base_type, :string
    add_column :quotes, :freight_subtype, :string
    remove_column :quotes, :freight_table
  end
end
