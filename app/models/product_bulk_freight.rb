class ProductBulkFreight < ApplicationRecord
  belongs_to :vehicle
  belongs_to :product
end
