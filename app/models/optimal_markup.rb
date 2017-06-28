class OptimalMarkup < ApplicationRecord
  belongs_to :product
  belongs_to :customer , required: false
  belongs_to :dist_center
  belongs_to :business_unit
  has_many :quotes

  validates_presence_of  :product_id, :dist_center_id, :table_value


  def self.xls_mode
    :create
  end

  def self.xls_fields
    {
      'product.sku': :f_key,
      'product.name': nil,
      'customer.code': :f_key,
      'customer.name': nil,
      'business_unit.code': :f_key,
      'dist_center.code': :f_key,
      table_value: :attr,
      value: :attr
    }
  end

  
end

# == Schema Information
#
# Table name: optimal_markups
#
#  id               :integer          not null, primary key
#  product_id       :integer
#  customer_id      :integer
#  dist_center_id   :integer
#  value            :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  table_value      :decimal(, )
#  business_unit_id :integer
#
# Indexes
#
#  index_optimal_markups_on_business_unit_id  (business_unit_id)
#  index_optimal_markups_on_customer_id       (customer_id)
#  index_optimal_markups_on_dist_center_id    (dist_center_id)
#  index_optimal_markups_on_product_id        (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (dist_center_id => dist_centers.id)
#  fk_rails_...  (product_id => products.id)
#
