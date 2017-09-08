class SimulatorService < PowerTypes::Service.new(:q)

  def run
    if @q.icms_padrao && @q.product.resolution13 && @q.origin_state != @q.destination_state
      @q.icms = 0.04
    elsif @q.icms_padrao
      @q.icms = IcmsTax.tax_value_for(@q.origin_state, @q.destination_state)
      error("Não encontrado para esta origem/destino", :icms) if @q.icms.nil?
    end

    @q.ipi = @q.product.ipi

    if @q.pis_confins_padrao
      # TODO QM validate presence when not padrao.
      # TODO Handle Sys Var Unset
      @q.pis_confins = SystemVariable.get :pis_confins
    end


    tax_d = 1 - @q.icms - @q.pis_confins
    base_price = calc_base_price
    unit_freight = @q.unit_freight * currency_conversor('brl', @q.currency)
    financial_cost = @q.financial_cost



    if @q.fixed_price
      @q.markup = (((((@q.unit_price * tax_d)/(1.0 + financial_cost)) - unit_freight ) / base_price) - 1.0).round(2)
      @q.fob_net_price = (base_price * (1.0 + @q.markup)).round(2)
    else
      @q.unit_price = ((((base_price * (1.0 + @q.markup)+ unit_freight))/tax_d) * (1.0 + financial_cost)).round(2)
      @q.fob_net_price = (base_price * (1.0 + @q.markup))
    end
  end

  def calc_base_price
    conversor = currency_conversor(@q.cost.currency, @q.currency)
    @q.cost.base_price * conversor / @q.cost.amount_for_price
  end

  def currency_conversor(from, to)
    case [from, to]
    when ['brl', 'usd']
      1.0 / @q.brl_usd
    when ['brl', 'eur']
      1.0 / @q.brl_eur
    when ['usd', 'brl']
      @q.brl_usd
    when ['usd', 'eur']
      @q.brl_usd / @q.brl_eur
    when ['eur', 'brl']
      @q.brl_eur
    when ['eur', 'usd']
      @q.brl_eur / @q.brl_usd
    else
      1.0
    end

  end

  def setup_cost_and_markup
    @q.cost = Cost.where(product: @q.product, dist_center: @q.dist_center).last
    @q.optimal_markup = OptimalMarkup.where(product: @q.product, dist_center: @q.dist_center, customer: @q.customer).last
    @q.optimal_markup ||= OptimalMarkup.where(product: @q.product, dist_center: @q.dist_center, customer_id: nil).last
    if @q.product && @q.dist_center
      error("Não for encontrada para o produto/CD selecionado", :cost) unless @q.cost
      error("não for encontrada para o produto/CD selecionado", :optimal_markup) unless @q.optimal_markup
    end
  end

  def error(msg, attr = :base)
    @q.errors.add(attr, msg)
  end
end
