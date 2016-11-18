class Good < ApplicationRecord
  has_many  :bill_items, dependent: :delete_all

  validates :name, presence: true, allow_blank: false
  validates :price, presence: true, numericality: { greater_than: 0.00 }
end
