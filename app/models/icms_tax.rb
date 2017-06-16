class IcmsTax < ApplicationRecord

  def self.origins
    self.distinct.order(:origin).pluck(:origin)
  end

  def self.destinations
    self.distinct.order(:destination).pluck(:destination)
  end

  def tax_value_for(origin, destination)
    self.where(origin: origin, destination: destination).last.try(:value)
  end
end

# == Schema Information
#
# Table name: icms_taxes
#
#  id          :integer          not null, primary key
#  origin      :string
#  destination :string
#  value       :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#