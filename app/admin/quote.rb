ActiveAdmin.register Quote do
  menu priority: 2
  before_action :set_user, only: [:create]
  actions :index, :new, :create, :edit, :update

  permit_params :user_id, :customer_id, :product_id, :quote_date, :payment_term, :icms_padrao,
                :icms, :ipi, :pis_confins_padrao, :pis_confins, :freight_condition,
                :brl_usd, :brl_eur, :quantity, :unit, :unit_price, :markup, :fixed_price,
                :optimal_markup_id, :cost_id, :fob_net_price, :freight_table,
                :final_freight, :comment, :dist_center_id, :city_id, :unit_freight

  form partial: 'form', title: 'Simulador de Preço'

  controller do

    def create
      create! do |format|
        format.html do
          if resource.errors.any?
            super
          else
            redirect_to edit_quote_path(resource)
          end
        end
      end
    end

    def build_new_resource
      q = super
      q.icms_padrao = true
      q.pis_confins_padrao = true
      q.freight_condition = :cif
      q.fixed_price = false
      q
    end

    def set_user
      params[:quote][:user_id]= current_user.id
    end
  end
end