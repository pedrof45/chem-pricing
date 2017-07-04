class Customer < ApplicationRecord
  has_many :optimal_markups
  has_many :quotes
  has_many :sales
  belongs_to :city
  belongs_to :country , required: false

  validates_presence_of :code

  def name_and_code
    "#{code} - #{name} - #{city.name}"
  end

 def self.xls_mode
    :update
  end

  def self.xls_fields
    {
      name: :attr,
      code: :key,
      cnpj: :attr,
	  'country.code': :f_key,
      'city.code': :f_key,
      contact: :attr,
      email: :attr
    }
  end


end

# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :integer
#  city_id    :integer
#  cnpj       :string
#  contact    :string
#
# Indexes
#
#  index_customers_on_city_id     (city_id)
#  index_customers_on_country_id  (country_id)
#
