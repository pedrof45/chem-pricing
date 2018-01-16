class Email < ApplicationRecord
  belongs_to :user
  belongs_to :customer
  has_and_belongs_to_many :quotes

  attr_accessor :contacts
  attr_accessor :quote_ids

  after_create :perform_send

  validates_presence_of :recipient, :user

  def perform_send
    QuoteMailer.send_with_sendgrid(self).deliver_later
  end
end

# == Schema Information
#
# Table name: emails
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  customer_id :integer
#  recipient   :string
#  subject     :string
#  message     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_emails_on_customer_id  (customer_id)
#  index_emails_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (user_id => users.id)
#
