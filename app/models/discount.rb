class Discount < ApplicationRecord
  has_many :bills, dependent: :nullify

  validates :value, numericality: { greater_than_or_equal_to: 0.00, less_than_or_equal_to: 100.00 }

  default_scope { order(:value) }
end
