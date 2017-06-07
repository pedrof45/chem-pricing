class Cost < ApplicationRecord
  belongs_to :product
  belongs_to :dist_center

  validates_presence_of :product_id, :dist_center_id, :base_price,
    :currency, :suggested_markup
end

# == Schema Information
#
# Table name: costs
#
#  id               :integer          not null, primary key
#  product_id       :integer
#  dist_center_id   :integer
#  base_price       :decimal(, )
#  currency         :string
#  suggested_markup :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
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
