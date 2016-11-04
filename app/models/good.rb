class Good < ApplicationRecord
  has_many  :bill_items

  validates :name, presence: true, allow_blank: false
  validates :price, presence: true
end
