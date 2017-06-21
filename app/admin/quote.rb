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

  csv do

    column :quote_date
    column("Usuario") { |m| m.user.fullname }
    column("Codigo Cliente") { |m| m.customer.code }
    column("SKU") { |m| m.product.sku }
    column("Moeda") { |m| m.cost.currency }
    column :quantity
    column :freight_condition
    column :freight_table
    column :icms_padrao
    column :icms
    column :pis_confins_padrao
    column :pis_confins
    column :ipi
    column :payment_term
    column("Preço Piso") { |m| m.cost.base_price}
    column :unit_price
    column("Unidade de Negocio") { |m| m.user.business_unit }
    column("CD") { |m| m.dist_center.name }
    column :markup
  end

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