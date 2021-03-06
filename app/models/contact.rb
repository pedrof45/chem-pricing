class Contact < ApplicationRecord
  belongs_to :customer

  def name_and_email
    "#{full_name} <#{email}>"
  end

  def full_name
    [first_name, last_name].join(' ')
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  first_name  :string
#  last_name   :string
#  email       :string
#  position    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_contacts_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
