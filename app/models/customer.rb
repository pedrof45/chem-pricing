class Customer < ApplicationRecord
  has_many :optimal_markups
  has_many :quotes
  has_many :sales
  belongs_to :city
  belongs_to :country , required: false

  validates_presence_of :code

  def name_and_code
    "#{name} - #{code}"
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
