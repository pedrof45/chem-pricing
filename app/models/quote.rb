class Quote < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :customer
  belongs_to :product
  belongs_to :dist_center
  belongs_to :city

  enumerize :freight_condition, in: [:cib, :fob, :redispatch]

end

# == Schema Information
#
# Table name: quotes
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  customer_id        :integer
#  product_id         :integer
#  quote_date         :datetime
#  payment_term       :string
#  icms_padrao        :boolean
#  icms               :decimal(, )
#  ipi                :decimal(, )
#  pis_confins_padrao :boolean
#  pis_confins        :decimal(, )
#  freight_condition  :string
#  brl_usd            :decimal(, )
#  brl_eur            :decimal(, )
#  quantity           :decimal(, )
#  unit               :string
#  unit_price         :decimal(, )
#  markup             :decimal(, )
#  fixed_price        :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  dist_center_id     :integer
#  city_id            :integer
#
# Indexes
#
#  index_quotes_on_city_id         (city_id)
#  index_quotes_on_customer_id     (customer_id)
#  index_quotes_on_dist_center_id  (dist_center_id)
#  index_quotes_on_product_id      (product_id)
#  index_quotes_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (user_id => users.id)
#
