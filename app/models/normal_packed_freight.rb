class NormalPackedFreight < ApplicationRecord
	extend Enumerize

	enumerize :category, in: [:pharma, :chemical]


	def self.xls_mode
    :update
  end

  def self.xls_fields
    {
      origin: :key,
      destination: :key,
      category: :key,
      amount: :attr,
      insurance: :attr,
      gris: :attr,
      toll: :attr,
      ct_e: :attr,
      min: :attr
    }
  end

end

# == Schema Information
#
# Table name: normal_packed_freights
#
#  id          :integer          not null, primary key
#  origin      :string
#  destination :string
#  category    :string
#  amount      :decimal(, )
#  insurance   :decimal(, )
#  gris        :decimal(, )
#  toll        :decimal(, )
#  ct_e        :decimal(, )
#  min         :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
