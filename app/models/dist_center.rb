class DistCenter < ApplicationRecord
  has_many :costs
  has_many :optimal_markups
end

# == Schema Information
#
# Table name: dist_centers
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
