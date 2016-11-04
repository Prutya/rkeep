class Bill < ApplicationRecord
  belongs_to :table
  has_many   :bill_items

  validates :people_number, presence: true
end
