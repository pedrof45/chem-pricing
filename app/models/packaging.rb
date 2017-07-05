class Packaging < ApplicationRecord

 def self.xls_mode
    :update
  end

  def self.xls_fields
    {
      code: :key,
      name: :attr,
      capacity: :attr,
      weight: :attr
    }
  end

end

# == Schema Information
#
# Table name: packagings
#
#  id         :integer          not null, primary key
#  code       :integer
#  name       :string
#  capacity   :decimal(, )
#  weight     :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
