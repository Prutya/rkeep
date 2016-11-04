class BillItem < ApplicationRecord
  belongs_to :user
  belongs_to :bill
  belongs_to :good
end
