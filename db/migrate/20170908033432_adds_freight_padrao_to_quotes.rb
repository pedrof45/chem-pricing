class AddsFreightPadraoToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :freight_padrao, :boolean
  end
end
