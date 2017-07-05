class ProductBulkFreight < ApplicationRecord
  belongs_to :vehicle
  belongs_to :product

def self.xls_mode
    :update
  end

  def self.xls_fields
    {
      origin: :key,
      destination: :key,
      'vehicle.name': :f_key,
      'product.sku': :f_key,
      amount: :attr,
      toll: :attr
    }
  end

end

# == Schema Information
#
# Table name: product_bulk_freights
#
#  id          :integer          not null, primary key
#  origin      :string
#  destination :string
#  vehicle_id  :integer
#  amount      :decimal(, )
#  product_id  :integer
#  toll        :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_product_bulk_freights_on_product_id  (product_id)
#  index_product_bulk_freights_on_vehicle_id  (vehicle_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (vehicle_id => vehicles.id)
#
