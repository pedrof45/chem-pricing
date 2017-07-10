class Vehicle < ApplicationRecord
  has_many :quotes

def self.xls_mode
    :update
  end

  def self.xls_fields
    {
      name: :key,
      capacity: :attr
    }
  end

end

# == Schema Information
#
# Table name: vehicles
#
#  id         :integer          not null, primary key
#  name       :string
#  capacity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_vehicles_on_name  (name)
#
