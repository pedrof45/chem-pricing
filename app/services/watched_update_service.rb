class WatchedUpdateService < PowerTypes::Service.new

  def run_for_upload(upload)
    Cost.where(upload: upload).each { |cost| run_for_cost(cost) }
  end

  def run_for_cost(cost)
    concerning_quotes(cost).each { |quote| update(quote) }
  end

  private

  def concerning_quotes(cost)
    Quote.watched_current.where(
      product: cost.product,
      dist_center: cost.dist_center
    )
  end

  def update(quote)
    new_quote = quote.dup
    reset_currencies(new_quote)
    new_quote.simulate!
    new_quote.save!
    # TODO handle if save fails
    quote.update(current: false)
  end

  def reset_currencies(quote)
    quote.brl_usd = nil
    quote.brl_eur = nil
  end
end
