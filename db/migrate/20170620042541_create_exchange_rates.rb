class CreateExchangeRates < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_rates do |t|
      t.string :from
      t.string :to
      t.decimal :value
      t.date :rate_date

      t.timestamps
    end
  end
end
