class Product < ApplicationRecord
	extend Enumerize

  has_many :costs
  has_many :optimal_markups
  has_many :quotes
  has_many :sales

  validates_presence_of :sku, :unit, :density
  validates :density, :numericality => { greater_than_or_equal_to: 0 }

  scope :with_cost, -> { joins(:costs).distinct }

  enumerize :unit, in: [:kg, :lt]

  def name_and_code
    "#{sku} - #{name}"
  end

  def self.xls_mode
    :update
  end

  def self.xls_fields
    {
      sku: :key,
      name: :attr,
      unit: :attr,
      ipi: :attr,
      density: :attr,
      resolution13: :attr,
      origin: :attr,
      ncm: :attr
    }
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
