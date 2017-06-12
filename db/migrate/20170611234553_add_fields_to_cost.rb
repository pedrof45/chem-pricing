class AddFieldsToCost < ActiveRecord::Migration[5.1]
  def change
    add_column :costs, :unit, :string
    add_column :costs, :amount_for_price, :decimal
    add_column :costs, :updated_cost, :boolean
    add_column :costs, :last_month_base_price, :decimal
    add_column :costs, :last_month_fob_net, :decimal
    add_column :costs, :product_analyst, :string
    add_column :costs, :lead_time, :integer
    add_column :costs, :min_order_quantity, :decimal
    add_column :costs, :frac_emb, :string
    add_column :costs, :source_adjustment, :decimal
    add_column :costs, :competition_adjustment, :decimal
    add_column :costs, :commentary, :decimal
  end
end
