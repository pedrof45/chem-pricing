class Vehicle < ApplicationRecord
  has_many :quotes

  scope :active, -> { where(active: true) }

def self.xls_mode
    :update
  end

  def self.xls_fields
    {
      name: :key,
      capacity: :attr,
      active: :attr
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
#  upload_id  :integer
#  active     :boolean          default(TRUE)
#
# Indexes
#
#  index_vehicles_on_name       (name)
#  index_vehicles_on_upload_id  (upload_id)
#
