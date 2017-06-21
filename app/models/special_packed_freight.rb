class SpecialPackedFreight < ApplicationRecord
end

# == Schema Information
#
# Table name: special_packed_freights
#
#  id          :integer          not null, primary key
#  origin      :string
#  destination :string
#  type        :string
#  amount      :decimal(, )
#  insurance   :decimal(, )
#  gris        :decimal(, )
#  toll        :decimal(, )
#  ct_e        :decimal(, )
#  min         :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
