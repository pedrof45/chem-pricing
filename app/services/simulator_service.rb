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


    interest = SystemVariable.get interest_sys_var

    if @q.payment_term == 0
      financial_cost = 0
    else
      #financial_cost = @q.payment_term * interest

      financial_cost = ((interest + 1.0)**(@q.payment_term/30.0)) -1.0
      #use this variable because was available...change name of final_freight to financial_cost
      @q.final_freight=financial_cost
      puts "encRGOS"
      puts financial_cost 
    end
    tax_d = 1 - @q.icms - @q.pis_confins

    #@q.unit_freight = 0.1 # TODO freight

    
    aux2=@q.cost.base_price

    
    @q.cost.base_price= aux2/@q.cost.amount_for_price

    

    if @q.fixed_price
      @q.markup = (((((@q.unit_price * tax_d)/(1.0 + financial_cost)) - @q.unit_freight ) / @q.cost.base_price) - 1.0).round(2)
      @q.fob_net_price = (@q.cost.base_price * (1.0 + @q.markup)).round(2)
      @q.markup*=100
    else
      if @q.markup>1
        @q.markup/=100
      end
      @q.unit_price = ((((@q.cost.base_price * (1.0 + @q.markup)+ @q.unit_freight))/tax_d) * (1.0 + financial_cost)).round(2)
      @q.fob_net_price = (@q.cost.base_price * (1.0 + @q.markup))
      if @q.markup>1
        @q.markup*=100
      end
     

    end

    # TODO additional product info (corresponds to simulation?)

  # rescue StandardError => e
  #   error(e.to_s)
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
