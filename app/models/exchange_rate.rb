class ExchangeRate < ApplicationRecord
end

# == Schema Information
#
# Table name: exchange_rates
#
#  id         :integer          not null, primary key
#  from       :string
#  to         :string
#  value      :decimal(, )
#  rate_date  :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
