class SystemVariable < ApplicationRecord
  def self.get(name)
    find_by(name: name).try :value
  end
end

# == Schema Information
#
# Table name: system_variables
#
#  id         :integer          not null, primary key
#  name       :string
#  value      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
