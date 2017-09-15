class WatchedUpdateService < PowerTypes::Service.new

  def run_for_upload(upload)
    if upload.model == 'cost'
    Cost.where(upload: upload).each { |cost| run_for_cost(cost) }
    elsif  upload.model.include?('freight')
      klass = Object.const_get upload.model.classify
      klass.where(upload: upload).each { |f_obj| run_for_freight_obj(f_obj) }
    else
      raise "Unhandled Watch Update Request for upload #{upload.id} model #{upload.model}"
    end
  end

  def run_for_cost(cost)
    concerning_quotes_for_cost(cost).each { |quote| update(quote) }
  end

  def run_for_freight_obj(obj)
    subtype, type = obj.class.name.underscore.split '_'
    subtype = 'special' if subtype == 'especial'
    if type == 'bulk' && subtype == 'chopped'
      subtype = "chopped_#{obj.id}"
    end
    run_for_freight(type, subtype)
  end

  def run_for_freight(type, subtype)
    concerning_quotes_for_freight(type, subtype).each  { |quote| update(quote) }
  end

  private

  def concerning_quotes_for_freight(type, subtype)
    Quote.watched_current.where(
        freight_base_type: type,
        freight_subtype: subtype
    )
  end

  def concerning_quotes_for_cost(cost)
    Quote.watched_current.where(
      product: cost.product,
      dist_center: cost.dist_center
    )
  end

  def update(quote)
    new_quote = quote.dup
    reset_currencies(new_quote)
    new_quote.save! # save calls simulate!
    # TODO handle if save fails
    quote.update_columns(current: false)
  end

  def reset_currencies(quote)
    quote.brl_usd = nil
    quote.brl_eur = nil
  end
end
