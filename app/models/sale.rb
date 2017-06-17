class Sale < ApplicationRecord
  belongs_to :customer
  belongs_to :product
  belongs_to :dist_center
  belongs_to :business_unit
end

# == Schema Information
#
# Table name: sales
#
#  id               :integer          not null, primary key
#  sale_date        :datetime
#  customer_id      :integer
#  product_id       :integer
#  dist_center_id   :integer
#  user_id          :integer
#  business_unit_id :integer
#  moneda           :string
#  unit             :string
#  volume           :decimal(, )
#  base_price       :decimal(, )
#  unit_price       :decimal(, )
#  calculated       :string
#  markup           :decimal(, )
#  comentario       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_sales_on_business_unit_id  (business_unit_id)
#  index_sales_on_customer_id       (customer_id)
#  index_sales_on_dist_center_id    (dist_center_id)
#  index_sales_on_product_id        (product_id)
#  index_sales_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (business_unit_id => business_units.id)
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (dist_center_id => dist_centers.id)
#  fk_rails_...  (product_id => products.id)
#
