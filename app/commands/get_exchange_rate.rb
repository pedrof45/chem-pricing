require 'money'
require 'money/bank/google_currency'

class GetExchangeRate < PowerTypes::Command.new(:from, :to)
  def perform
    todays = ExchangeRate.find_by(from: @from, to: @to, rate_date: Date.today)
    if todays
      rate = todays.value
    else
      Money.default_bank = Money::Bank::GoogleCurrency.new
      rate = Money.default_bank.get_rate(@from, @to)
      ExchangeRate.create(from: @from, to: @to, rate_date: Date.today, value: rate)
    end
    rate
    # TEMP DUE TO EXCHANGE GEM ISSUES 05/06/2018
  rescue StandardError => ex
    Raven.capture_exception(ex)
    puts "Error fetching exchange rate at #{Time.current}"
    ExchangeRate.where(from: @from, to: @to).last.try(:value)
  end
end
