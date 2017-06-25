class Vehicle < ApplicationRecord
  has_many :quotes
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
