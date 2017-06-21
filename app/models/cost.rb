class Cost < ApplicationRecord
	extend Enumerize

  belongs_to :product
  belongs_to :dist_center
  has_many :quotes

  validates_presence_of :product_id, :dist_center_id, :base_price,
    :currency, :amount_for_price

  enumerize :currency, in: [:brl, :usd, :eur]
end

# == Schema Information
#
# Table name: costs
#
#  id                     :integer          not null, primary key
#  product_id             :integer
#  dist_center_id         :integer
#  base_price             :decimal(, )
#  currency               :string
#  suggested_markup       :decimal(, )
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  amount_for_price       :decimal(, )
#  updated_cost           :boolean
#  last_month_base_price  :decimal(, )
#  last_month_fob_net     :decimal(, )
#  product_analyst        :string
#  lead_time              :integer
#  min_order_quantity     :decimal(, )
#  source_adjustment      :decimal(, )
#  competition_adjustment :decimal(, )
#  commentary             :string
#  on_demand              :string
#  frac_emb               :boolean
#
# Indexes
#
#  index_costs_on_dist_center_id  (dist_center_id)
#  index_costs_on_product_id      (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (dist_center_id => dist_centers.id)
#  fk_rails_...  (product_id => products.id)
#
