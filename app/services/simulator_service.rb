class SimulatorService < PowerTypes::Service.new(:quote)

  def run
    @quote.cost = Cost.where(product: @quote.product, dist_center: @quote.dist_center).last
    @quote.markup = OptimalMarkup.where(product: @quote.product, dist_center: @quote.dist_center, customer: @quote.customer).last

    # TODO handle if cost/markup not found

    origin_state = @quote.dist_center.city.state

    # TODO QM handle require redispatch city (specially if no customer!)
    destination_state = if @quote.freight_condition.redispatch?
                          @quote.city.state
                        else
                          @quote.customer.city
                        end

    if @quote.icms_padrao && @quote.product.resolution13 && origin_state != destination_state
      @quote.icms = 0.04
    elsif @quote.icms_padrao
      # TODO handle IcmsTax not found for origin/destiny
      @quote.icms = IcmsTax.tax_value_for(origin_state, destination_state)
    end

    if @quote.pis_confins_padrao
      # TODO QM validate presence when not padrao.
      # TODO Handle Sys Var Unset
      @quote.pis_confins = SystemVariable.get :pis_confins
    end

    # TODO validate payment term range ( > 0? )
    # TODO Handle Sys Var Unset
    interest_sys_var = case @quote.payment_term
                       when (0..30)
                         :interest_2_30
                       when (31..60)
                         :interest_31_60
                       else
                         :interest_more_60
                       end

    interest = SystemVariable.get interest_sys_var

    financial_cost = @quote.payment_term * interest





    # TODO preçio fob
    # TODO additional product info (corresponds to simulation?)
  end
end
