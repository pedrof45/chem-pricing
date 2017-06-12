class City < ApplicationRecord

  def state
    code[0..1] if code
  end

end

# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
