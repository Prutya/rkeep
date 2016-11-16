class Shift < ApplicationRecord
  has_many :bills
  has_many :spendings
  has_many :user_shifts
  has_many :users, through: :user_shifts

  validates :total,           numericality: { greater_than_or_equal_to: 0.00 }
  validates :total_revenue,   numericality: { greater_than_or_equal_to: 0.00 }
  validates :total_spendings, numericality: { greater_than_or_equal_to: 0.00 }

  def closed?
    self.closed_at.present?
  end

  def calculate_total_revenue
    bills.sum(&:total)
  end

  def calculate_total_spendings
    self.spendings.inject(0) { |total, spending| spending.cancelled? ? total : total + spending.total }
  end
end
