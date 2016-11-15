class Shift < ApplicationRecord
  has_many :bills
  has_many :spendings
  has_many :user_shifts
  has_many :users, through: :user_shifts

  validates :total,         numericality: { greater_than_or_equal_to: 0.00 }
  validates :subtotal,      numericality: { greater_than_or_equal_to: 0.00 }
end
