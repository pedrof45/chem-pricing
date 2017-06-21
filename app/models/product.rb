class Product < ApplicationRecord
	extend Enumerize

  has_many :costs
  has_many :optimal_markups
  has_many :quotes
  has_many :sales

  validates_presence_of :sku, :unit, :density, :resolution13


  enumerize :unit, in: [:kg, :lt]

  def name_and_code
    "#{name} - #{sku}"
  end


end

# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  sku          :string
#  name         :string
#  unit         :string
#  ipi          :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  density      :decimal(, )
#  resolution13 :boolean
#  origin       :integer
#  ncm          :string
#
