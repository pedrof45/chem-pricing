class User < ApplicationRecord
  extend Enumerize
  
  has_many :quotes
  belongs_to :business_unit , required: false

  validates_presence_of :email, :encrypted_password, :role

  enumerize :role, in: [:sysadmin, :admin, :manager, :agent]


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  def to_s
    email
  end

  def name
    email
  end

  def full_name
    [first_name, last_name].join ' '
  end

  def sysadmin_or_more?
    role.sysadmin?
  end

  def admin_or_more?
    role.admin? || role.sysadmin?
  end

  def manager_or_more?
    role.manager? || role.admin? || role.sysadmin?
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  position               :string
#  role                   :string
#  active                 :boolean
#  business_unit_id       :integer
#
# Indexes
#
#  index_users_on_business_unit_id      (business_unit_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
