class Spending < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, allow_blank: false
  validates :total, presence: true, numericality: { greater_than: 0.00 }
end
