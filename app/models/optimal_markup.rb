class OptimalMarkup < ApplicationRecord
  belongs_to :product
  belongs_to :customer
  belongs_to :dist_center
end

# == Schema Information
#
# Table name: optimal_markups
#
#  id             :integer          not null, primary key
#  product_id     :integer
#  customer_id    :integer
#  dist_center_id :integer
#  value          :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_optimal_markups_on_customer_id     (customer_id)
#  index_optimal_markups_on_dist_center_id  (dist_center_id)
#  index_optimal_markups_on_product_id      (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (dist_center_id => dist_centers.id)
#  fk_rails_...  (product_id => products.id)
#
