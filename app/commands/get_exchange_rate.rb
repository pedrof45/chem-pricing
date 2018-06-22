# require 'money'
# require 'money/bank/google_currency'
require 'net/http'
require 'json'

class GetExchangeRate < PowerTypes::Command.new(:from, :to)
  def perform
    raise "Currency 'from' or 'to' is blank" unless @from.present? && @to.present?
    return 1.0 if @from == @to
    todays = ExchangeRate.find_by(from: @from, to: @to, rate_date: Date.today)
    if todays
      rate_value = todays.value
    else
      rate_value = query_currency_layer_api.round(4)
      ExchangeRate.create(from: @from, to: @to, rate_date: Date.today, value: rate_value)
    end
    rate_value
  end

  # NOT WORKING
  def query_google_curency
    Money.default_bank = Money::Bank::GoogleCurrency.new
    Money.default_bank.get_rate(@from, @to)
  end

  def query_currency_layer_api
    api_key = ENV.fetch('CURRENCY_LAYER_API_KEY')
    url = "http://www.apilayer.net/api/live?access_key=#{api_key}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    rates = JSON.parse(response).fetch('quotes')
    usd_eur = rates.fetch('USDEUR')
    usd_brl = rates.fetch('USDBRL')
    raise "Rates type error: #{usd_eur.class.name}" unless [usd_eur, usd_brl].map {|r| r.class.name }.uniq == ['Float']
    case [@from.to_sym, @to.to_sym]
    when [:BRL, :EUR]
      usd_eur / usd_brl
    when [:BRL, :USD]
      1.0 / usd_brl
    when [:EUR, :BRL]
       usd_brl / usd_eur
    when [:EUR, :USD]
      1.0 / usd_eur
    when [:USD, :BRL]
      usd_brl
    when [:USD, :EUR]
      usd_eur
    end
  end
end
