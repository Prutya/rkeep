class User < ApplicationRecord
  has_many :assignments
  has_many :spendings
  has_many :bill_items
  has_many :roles, through: :assignments

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :first_name, presence: true, allow_blank: false
  validates :last_name,  presence: true, allow_blank: false
  validates :phone,      presence: true, allow_blank: false
end
