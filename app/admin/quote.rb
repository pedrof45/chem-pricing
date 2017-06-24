ActiveAdmin.register Quote do
  menu priority: 2, label: '1. Cotaçao'
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
    column("Usuario") { |m| m.user.full_name }
    column("Codigo Cliente") { |m| m.customer.code if m.customer }
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
    column("Unidade de Negocio") { |m| m.user.business_unit.code }
    column("CD") { |m| m.dist_center.name }
    column :fixed_price
    column :markup
  end

  controller do

    def create
      create! do |format|
        format.html do
          if resource.errors.any?
            flash.now[:error] = resource.errors.to_a.join("<br/>").html_safe
            render 'form'
          else
            redirect_to edit_quote_path(resource), flash: { notice: "Cotaçao simulada com sucesso!" }
          end
        end
      end
    end

    def build_new_resource
      q = super

      if action_name == 'new'
        # temp
        q.dist_center = DistCenter.take
        q.customer = Customer.take
        q.product = Product.take

        q.brl_usd = GetExchangeRate.for(from: :USD, to: :BRL)
        q.brl_eur = GetExchangeRate.for(from: :EUR, to: :BRL)

        q.icms_padrao = true
        q.pis_confins_padrao = true
        q.freight_condition = :cif
        q.fixed_price = false
      end
      q
    end

    def set_user
      params[:quote][:user_id] = current_user.id
    end
  end
end