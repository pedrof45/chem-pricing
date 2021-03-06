ActiveAdmin.register Quote do
  menu priority: 2, label: '1. Cotações'
  before_action :set_user, only: [:create]
  actions :index, :new, :create, :edit, :update

  permit_params :user_id, :customer_id, :product_id, :quote_date, :payment_term, :icms_padrao,
                :icms, :ipi, :pis_confins_padrao, :pis_confins, :freight_condition,
                :brl_usd, :brl_eur, :quantity, :unit, :unit_price, :markup, :fixed_price,
                :optimal_markup_id, :cost_id, :fob_net_price,
                :final_freight, :comment, :dist_center_id, :city_id, :unit_freight,
                :freight_base_type, :freight_subtype, :vehicle_id, :freight_padrao, :currency, :watched,
                :payment_term_description

  form partial: 'form', title: 'Simulador de Preço'

  scope 'Monitorada - Vigente', :watched_current, default: true
  scope 'Todas', :all

  filter :id
  filter :code
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

  index(download_links: [:json, :csv, :xlsx]) do
    selectable_column
    id_column
    column :code
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
    column :freight_condition, &:freight_condition_text
    column :freight_base_type, &:freight_base_type_text
    column :freight_subtype, &:freight_subtype_text
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
    column :payment_term_description
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
    def index
      respond_to do |format|
      format.xlsx {
        path = BuildXlsx.for(quotes: batch_action_collection)
        send_file(path) && return
      }
      format.html { super }
      format.csv { super }
      format.json { super }
      end
    end

    def create
      create! do |format|
        format.html do
          if resource.errors.any?
            flash.now[:error] = resource.errors.to_a.join("<br/>").html_safe
            render 'form'
          else
            flash_obj = if resource.below_markup?
                          { notice: "Cotaçao simulada! id: ##{resource.id} / codigo: #{resource.code}", error: 'Você está cotando abaixo do mark-up tabela!' }
                        else
                          { notice: "Cotaçao simulada com sucesso! id: ##{resource.id} / codigo: #{resource.code}" }
                        end
            redirect_to edit_quote_path(resource), flash: flash_obj
          end
        end
      end
    end

    def update
      super do
        flash_obj = if resource.below_markup?
                      { notice: "Cotaçao atualizada! id: ##{resource.id} / codigo: #{resource.code}", error: 'Você está cotando abaixo do mark-up tabela!' }
                    else
                      { notice: "Cotaçao atualizada com sucesso! id: ##{resource.id} / codigo: #{resource.code}" }
                    end
        redirect_to(edit_quote_path(resource), flash: flash_obj) &&  return if resource.errors.empty?
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
    product = Product.find_by(id: params[:product_id])
    # redispatch = params[:redispatch] NOT USED ANYMORE
    origin_city = dist_center&.city
    destination_city = customer&.city || city
    icms =
      if product&.resolution13 && origin_city&.state && destination_city&.state && (origin_city.state != destination_city.state)
        0.04
      else
        # IcmsTax.tax_value_for(origin_state, destination_state) # NOT USED ANYMORE
        TaxService.new.icms_for(customer, product, origin_city&.code, destination_city&.code)
      end
    resp = { icms: icms, origin: origin_city&.state, destination: destination_city&.state }
    puts "FETCH ICMS RESPONSE: #{resp}"
    render json: resp
  end

  collection_action :fetch_financial_cost, method: :get do
    payment_term = params[:payment_term].to_i
    value = 100 * CalcFinancialCost.for(payment_term: payment_term)
    resp = { value: "#{value.round(3)}%" }
    puts "FETCH FINANCIAL COST RESPONSE: #{resp}"
    render json: resp
  end

  member_action :unwatch, method: :patch do
    resource.update_columns(watched: false, current: false)
    redirect_to quotes_path(scope: 'todas'), notice: "Cotação não será mais monitorada"
  end

  batch_action :send_email, label: 'blah' do |ids, input|
    quotes = Quote.where(id: ids)
    if quotes.empty?
      error = 'Erro: Nenhuma cotaçao selecionada'
    else
      customers = quotes.map(&:customer).uniq
      if customers.size > 1
        error = 'Erro: Cotações devem ser do mesmo cliente para enviar email'
      elsif customers.first.nil?
        error = 'Erro: Cotaçao deve ter um cliente'
      end
    end

    if error.present?
      flash[:error] = error
      redirect_back fallback_location: quotes_path
    else
      customer = customers.first
      redirect_to new_email_path(customer_id: customer.id, quote_ids: quotes.map(&:id))
    end
  end
end