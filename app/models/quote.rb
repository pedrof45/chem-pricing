class Quote < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :customer
  belongs_to :product
  belongs_to :dist_center
  belongs_to :city
  belongs_to :cost, required: false
  belongs_to :optimal_markup, required: false

  before_create :simulate!

  validates_presence_of :freight_condition, :quantity

  enumerize :freight_condition, in: [:cif, :fob, :redispatch]
  enumerize :unit, in: [:kg, :lt]

  def simulate!
    SimulatorService.new(quote: self).run
  end

  def last_sale
    if customer && product && dist_center
      product.sales.where(customer: customer, dist_center: dist_center).last
    elsif product && dist_center
      product.sales.where(dist_center: dist_center).last
    end
  end

  def total_price
    unit_price.to_i * quantity.to_i
  end

  def optimal_markup
    if product && customer
      product.optimal_markups.where(customer: customer).last.try :value
    elsif product
      product.optimal_markups.where(customer: nil).last.try :value
    end
  end

  def mcb
    total_price - (cost.base_price * quantity)
  end
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
#  optimal_markup_id  :integer
#  cost_id            :integer
#  fob_net_price      :decimal(, )
#  freight_table      :integer
#  final_freight      :decimal(, )
#  comment            :string
#  unit_freight       :decimal(, )
#
# Indexes
#
#  index_quotes_on_city_id            (city_id)
#  index_quotes_on_cost_id            (cost_id)
#  index_quotes_on_customer_id        (customer_id)
#  index_quotes_on_dist_center_id     (dist_center_id)
#  index_quotes_on_optimal_markup_id  (optimal_markup_id)
#  index_quotes_on_product_id         (product_id)
#  index_quotes_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (user_id => users.id)
#
