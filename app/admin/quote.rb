ActiveAdmin.register Quote do
  menu priority: 2
  # before_action :set_product, only: [:show, :edit, :update, :destroy]

  permit_params :user_id, :customer_id, :product_id, :quote_date, :payment_term, :icms_padrao,
                :icms, :ipi, :pis_confins_padrao, :pis_confins, :freight_condition,
                :brl_usd, :brl_eur, :quantity, :unit, :unit_price, :markup, :fixed_price,
                :optimal_markup_id, :cost_id, :fob_net_price, :freight_table,
                :final_freight, :comment, :dist_center_id, :city_id, :unit_freight

  form partial: 'form', title: 'Simulador de Preço'
end