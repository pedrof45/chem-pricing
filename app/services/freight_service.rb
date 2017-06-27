class FreightService < PowerTypes::Service.new(:q)

  def run
    return 0 if @q.freight_condition.fob?
    splited_subtype = @q.freight_subtype.split '_'
    @subtype = splited_subtype.first
    @op_id = splited_subtype.last if splited_subtype.length > 1
    run_freight_by_type @q.freight_base_type, @subtype
    unless @freight
      error('Problema encontrado calculando o frete')
      return 1
    end

    convert_unit
    convert_currency
    @q.unit_freight = @freight.round(4)
  end

  private


  def convert_unit
    if @q.freight_base_type.bulk? && @subtype == 'normal'
      @freight *= @q.product.density if @q.product.unit.kg?
    else
      @freight /= @q.product.density if @q.product.unit.lt?
    end
  end

  def convert_currency

   @q.cost = Cost.where(product: @q.product, dist_center: @q.dist_center).last
    @q.optimal_markup = OptimalMarkup.where(product: @q.product, dist_center: @q.dist_center, customer: @q.customer).last
    if @q.product && @q.dist_center
      error("Não for encontrada para o produto/CD selecionado", :cost) unless @q.cost
      error("não for encontrada para o produto/CD selecionado", :optimal_markup) unless @q.optimal_markup
    end

    # up to this point, the simulation aborts if quote has errors
    return if @q.errors.any?
    
    @freight *= @q.brl_usd if @q.cost.currency.usd?
    @freight *= @q.brl_eur if @q.cost.currency.eur?
  end

  def run_freight_by_type(type, subtype)
    send("#{type}_#{subtype[/([a-z]+)/]}")
  end

  def bulk_normal
    freight_obj = NormalBulkFreight.where(origin: @q.dist_center.city.code, destination: @q.customer.city.code , vehicle: @q.vehicle).last
    unless freight_obj
      puts @q.dist_center.city.code
      puts @q.customer.city.code
      puts @q.vehicle.id
      return error('Frete Granel - Normal não foi encontrado pelo origem/destino/veiculo dado')
    end
    amount = freight_obj.amount
    toll = freight_obj.toll
    capacity = @q.vehicle.capacity
    volume = @q.quantity_lts

    @freight = (((amount / 1000) * (capacity * 1000)) + (toll * volume/1000)) / volume
  end

  def bulk_chopped
    freight_obj = ChoppedBulkFreight.find(@op_id)
    # TODO handle obj not found
    amount = freight_obj.amount
    @freight = amount * 0.001
  end

  def bulk_product
    freight_obj = ProductBulkFreight.where(origin: @q.dist_center.city.code, destination: @q.customer.city.code , vehicle: @q.vehicle, product: @q.product).last
    unless freight_obj
      return error('Frete Granel - Produto não foi encontrado pelo origem/destino/veiculo/produto dado')
    end
    amount = freight_obj.amount
    toll = freight_obj.toll
    weight = @q.quantity_kgs

    @freight = (((amount / 1000) * (weight)) + (toll * weight/1000)) / weight
  end

  def packed_special
    freight_obj = EspecialPackedFreight.where(origin: @q.dist_center.city.code, destination: @q.customer.city.code , vehicle: @q.vehicle).last
    unless freight_obj
      return error('Frete Embalado - Especial não foi encontrado pelo origem/destino/veiculo dado')
    end
    amount = freight_obj.amount
    weight = @q.quantity_kgs

    @freight = (amount) / weight
  end

  def packed_pharma
    packed_normal_calc
  end

  def packed_chemical
    packed_normal_calc
  end

  def packed_normal_calc

    @q.cost = Cost.where(product: @q.product, dist_center: @q.dist_center).last
    @q.optimal_markup = OptimalMarkup.where(product: @q.product, dist_center: @q.dist_center, customer: @q.customer).last
    if @q.product && @q.dist_center
      error("Não for encontrada para o produto/CD selecionado", :cost) unless @q.cost
      error("não for encontrada para o produto/CD selecionado", :optimal_markup) unless @q.optimal_markup
    end

    # up to this point, the simulation aborts if quote has errors
    return if @q.errors.any?

    freight_obj = NormalPackedFreight.where(origin: @q.dist_center.city.code, destination: @q.customer.city.code , category: @subtype).last
    unless freight_obj
      return error('Frete Embalado Normal não foi encontrado pelo origem/destino/tipo dado')
    end
    amount = freight_obj.amount
    insurance = freight_obj.insurance
    gris = freight_obj.gris
    toll = freight_obj.toll
    ct_e = freight_obj.ct_e
    minimum = freight_obj.min
    weight = @q.quantity_kgs
    unless @q.cost
      return error('Não foi possível obter preço piso')
    end

    base_price = @q.cost.base_price/@q.cost.amount_for_price
    total_freight = ((amount / 1000) * weight) + (gris * base_price * weight) + (insurance * base_price * weight) + (weight / 100 * toll).ceil + ct_e
    total_freight = minimum if total_freight < minimum
    @freight = total_freight / weight
  end

  def error(msg, attr = :base)
    @q.errors.add(attr, msg)
  end
end
