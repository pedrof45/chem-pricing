ActiveAdmin.register Quote do
  menu priority: 2, label: '1. Cotaçao'
  before_action :set_user, only: [:create]
  actions :index, :new, :create, :edit, :update

  permit_params :user_id, :customer_id, :product_id, :quote_date, :payment_term, :icms_padrao,
                :icms, :ipi, :pis_confins_padrao, :pis_confins, :freight_condition,
                :brl_usd, :brl_eur, :quantity, :unit, :unit_price, :markup, :fixed_price,
                :optimal_markup_id, :cost_id, :fob_net_price,
                :final_freight, :comment, :dist_center_id, :city_id, :unit_freight,
                :freight_base_type, :freight_subtype, :vehicle_id, :freight_padrao, :currency, :watched

  form partial: 'form', title: 'Simulador de Preço'

  scope 'Monitorada - Vigente', :watched_current, default: true
  scope 'Todas', :all

  filter :watched
  filter :current
  filter :user
  filter :customer
  filter :product
  filter :dist_center
  filter :icms_padrao
  filter :pis_confins_padrao
  filter :freight_condition
  filter :fixed_price
  filter :freight_base_type
  filter :freight_subtype
  filter :upload
  filter :currency
  filter :freight_padrao

  index do
    id_column
    column :watched
    bool_column :current
    column :user
    column :customer
    column :product
    column :created_at
    column :icms_padrao
    column :icms
    column :ipi
    column :pis_confins_padrao
    column :pis_confins
    column :freight_condition
    column :freight_base_type
    column :freight_subtype
    column :city
    column :unit_freight
    column("Veiculo") { |m| m.vehicle.name if m.vehicle }
    column("Moeda") { |m| m.cost.currency.upcase if m.cost }
    column :brl_usd
    column :brl_eur
    column :quantity
    column("Unidade") { |m| m.product.unit.upcase}
    column :unit_price
    column :markup
    column :fixed_price
    column :dist_center
    column("Unidade de Negocio") { |m| m.user.business_unit.code if m.user }
    column("Preço Piso") { |m| m.cost.base_price if m.cost }
    column :comment
    column :payment_term
    actions defaults: false do |quote|
      item 'Editar', edit_quote_path(quote), class: 'member_link' if quote.watched_current?
      item 'Não Monitorear', unwatch_quote_path(quote), method: :patch, class: 'member_link' if quote.watched_current?
      item 'Use como base para novo', edit_quote_path(quote), class: 'member_link' unless quote.watched_current?
    end
  end

    csv do
    build_csv_columns(:quote).each do |k, v|
      column(k, humanize_name: false, &v)
    end
  end

  action_item :upload do
    link_to 'Cotaçao Batch', new_upload_path(model: :quote)
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

    def update
      super do
        redirect_to(edit_quote_path(resource), flash: { notice: "Cotaçao atualizada com sucesso!" }) &&  return if resource.errors.empty?
      end
    end

    def build_new_resource
      q = super

      if action_name == 'new'
        # temp
        # q.dist_center = DistCenter.take
        # q.customer = Customer.take
        # q.product = Product.take

        q.currency = :brl
        q.unit = :kg


        q.brl_usd = GetExchangeRate.for(from: :USD, to: :BRL)
        q.brl_eur = GetExchangeRate.for(from: :EUR, to: :BRL)

        q.freight_padrao = true
        q.freight_base_type = Quote.freight_base_type.bulk
        q.icms_padrao = true
        q.pis_confins_padrao = true
        q.pis_confins = SystemVariable.get(:pis_confins)
        q.freight_condition = :cif
        q.fixed_price = false
      end
      q
    end

    def set_user
      params[:quote][:user_id] = current_user.id
    end
  end

  collection_action :fetch_data, method: :get do
      dist_center = DistCenter.find_by(id: params[:dist_center_id])
      product = Product.find_by(id: params[:product_id])
      customer = Customer.find_by(id: params[:customer_id])
      o_mkup = OptimalMarkup.where(product: product, dist_center: dist_center, customer: customer).last
      unless o_mkup
        o_mkup = OptimalMarkup.where(product: product, dist_center: dist_center, customer: nil).last
      end
      cost = Cost.where(product: product, dist_center: dist_center).last
      resp = { table_value: o_mkup.try(:table_value),
               unit: product.try(:unit),
               currency: cost.try(:currency) }
      puts "FETCH DATA RESPONSE: #{resp}"
      render json: resp
  end

  collection_action :fetch_icms, method: :get do
    dist_center = DistCenter.find(params[:dist_center_id])
    customer = Customer.find_by(id: params[:customer_id])
    city = City.find_by(id: params[:city_id])

    origin = dist_center.city.state
    destination = customer&.city&.state || city&.state
    icms = IcmsTax.tax_value_for(origin, destination)
    resp = { icms: icms, origin: origin, destination: destination }
    puts "FETCH ICMS RESPONSE: #{resp}"
    render json: resp
  end

  member_action :unwatch, method: :patch do
    resource.update_columns(watched: false, current: false)
    redirect_to quotes_path(scope: 'todas'), notice: "Cotação não será mais monitorada"
  end
end