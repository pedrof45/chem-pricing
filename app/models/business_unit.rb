class BusinessUnit < ApplicationRecord
  has_many :users
  has_many :optimal_markups

  validates_presence_of :code

end

# == Schema Information
#
# Table name: business_units
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_business_units_on_code  (code)
#
