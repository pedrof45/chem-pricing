class Product < ApplicationRecord
	extend Enumerize

  has_many :costs
  has_many :optimal_markups
  has_many :quotes
  has_many :sales

  validates_presence_of :sku, :unit, :density, :resolution13


  enumerize :unit, in: [:kg, :lt]


end

# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  sku          :string
#  name         :string
#  unit         :string
#  currency     :string
#  ipi          :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  density      :decimal(, )
#  resolution13 :boolean
#  origin       :integer
#  commodity    :boolean
#  ncm          :string
#
