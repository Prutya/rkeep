class User < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :bills, dependent: :nullify
  has_many :user_shifts, dependent: :destroy

  has_many :shifts, through: :user_shifts
  has_many :roles, through: :assignments

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true, allow_blank: false
  validates :last_name,  presence: true, allow_blank: false
  validates :phone,      presence: true, allow_blank: false

  default_scope { order(:last_name) }

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    role?(:admin)
  end

  def employee?
    role?(:employee)
  end

  def at_shift?(shift)
    shift.users.any? { |u| u.id == self.id }
  end

  def busy?(shift = self.last_shift)
    shift && !shift.closed?
  end

  def last_shift
    self.shifts.order(:opened_at).last
  end

  protected

  def role?(role)
    roles.any? { |r| r.name.underscore.to_sym == role }
  end
end
