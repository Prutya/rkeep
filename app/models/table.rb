class Table < ApplicationRecord
  has_many :bills, dependent: :nullify

  validates :name, presence: true, allow_blank: false
end
