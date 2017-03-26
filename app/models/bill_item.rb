class BillItem < ApplicationRecord
  belongs_to :bill
  belongs_to :good

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def calculate_subtotal
    (self.quantity * self.good.price).round(2)
  end

  def calculate_total(discount)
    (calculate_subtotal * (100 - discount) / 100).round(2)
  end

  def cancel(cancel_time = Time.zone.now)
    self.time_cancel = cancel_time
  end
end
