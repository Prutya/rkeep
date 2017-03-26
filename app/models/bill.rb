class Bill < ApplicationRecord
  belongs_to :table
  belongs_to :shift
  belongs_to :discount
  has_many   :bill_items, dependent: :delete_all

  validates :people_number, presence: true, numericality: { greater_than: 0 }

  default_scope { order(created_at: :desc) }

  def status
    return :cancelled if self.time_cancel
    return :closed    if self.time_close
    :open
  end

  def closed?
    self.status == :closed
  end

  def cancelled?
    self.status == :cancelled
  end

  def calculate_subtotal
    amount = bill_items.inject(0) do |total, item|
      if item.time_cancel
        total
      else
        total += item.good.price * item.quantity
      end
    end

    amount.round(2)
  end

  def calculate_total
    (calculate_subtotal * (100 - self.discount.value) / 100).round(2)
  end

  def close(close_time = Time.zone.now)
    self.time_close = close_time
    self.subtotal = self.calculate_subtotal
    self.total = self.calculate_total
  end

  def cancel(cancel_time = Time.zone.now)
    self.time_cancel = cancel_time
  end
end
