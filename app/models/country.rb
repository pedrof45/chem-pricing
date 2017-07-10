class Country < ApplicationRecord
end

# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_countries_on_code  (code)
#
