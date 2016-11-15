class Shift < ApplicationRecord
  has_many :bills
  has_many :spendings
  has_many :user_shifts
  has_many :users, through: :user_shifts
end
