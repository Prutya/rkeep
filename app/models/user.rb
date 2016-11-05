class User < ApplicationRecord
  has_many :assignments
  has_many :spendings
  has_many :bill_items
  has_many :roles, through: :assignments

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true, allow_blank: false
  validates :last_name,  presence: true, allow_blank: false
  validates :phone,      presence: true, allow_blank: false

  def admin?
    role?(:admin)
  end

  def employee?
    role?(:employee)
  end

  protected

  def role?(role)
    roles.any? { |r| r.name.underscore.to_sym == role }
  end
end
