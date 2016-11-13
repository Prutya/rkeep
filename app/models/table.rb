class Table < ApplicationRecord
  has_many :bills

  validates :name, presence: true, allow_blank: false
end
