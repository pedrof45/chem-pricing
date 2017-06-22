class SimulatorService < PowerTypes::Service.new(:q)

  def run
    @q.cost = Cost.where(product: @q.product, dist_center: @q.dist_center).last
    @q.optimal_markup = OptimalMarkup.where(product: @q.product, dist_center: @q.dist_center, customer: @q.customer).last
    if @q.product && @q.dist_center
      error("Preço Base não for encontrada para o produto/CD selecionado") unless @q.cost
      error("Markup não for encontrada para o produto/CD selecionado") unless @q.optimal_markup
    end

    origin_state = @q.dist_center.city.state

    destination_state = if @q.customer.blank? || @q.freight_condition.redispatch?
                          @q.city.state
                        else
                          @q.customer.city.state
                        end

    if @q.icms_padrao && @q.product.resolution13 && origin_state != destination_state
      @q.icms = 0.04
    elsif @q.icms_padrao
      @q.icms = IcmsTax.tax_value_for(origin_state, destination_state)
      error("Não encontrado para esta origem/destino", :icms) if @q.icms.nil?
    end

    if @q.pis_confins_padrao
      # TODO QM validate presence when not padrao.
      # TODO Handle Sys Var Unset
      @q.pis_confins = SystemVariable.get :pis_confins
    end

    # TODO validate payment term range ( > 0? )
    # TODO Handle Sys Var Unset
    interest_sys_var = case @q.payment_term
                       when (0..30)
                         :interest_2_30
                       when (31..60)
                         :interest_31_60
                       else
                         :interest_more_60
                       end

    # up to this point, the simulation aborts if quote has errors
    return if @q.errors.any?

    interest = SystemVariable.get interest_sys_var
    financial_cost = @q.payment_term * interest
    tax_d = 1 - @q.icms - @q.pis_confins

    @q.unit_freight = 0.1 # TODO freight

    if @q.fixed_price
      @q.markup = (((((@q.unit_price * tax_d)/(1 + financial_cost)) - @q.unit_freight ) / @q.cost.base_price) - 1).round(3)
      @q.fob_net_price = @q.cost.base_price * @q.markup
    else
      @q.unit_price = ((((@q.cost.base_price * (1 + @q.markup)+ @q.unit_freight))/tax_d) * (1 + financial_cost)).round(2)
    end

    # TODO additional product info (corresponds to simulation?)

  # rescue StandardError => e
  #   error(e.to_s)
  end

  def error(msg, attr = nil)
    error_atr = attr.nil? ? :base : attr.to_sym
    @q.errors.add(error_atr, msg)
  end
end
