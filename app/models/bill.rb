class Bill < ApplicationRecord
  belongs_to :table
  belongs_to :user
  belongs_to :discount
  has_many   :bill_items, dependent: :delete_all

  validates :people_number, presence: true, numericality: { greater_than: 0 }
  validates :total,         numericality: { greater_than_or_equal_to: 0.00 }
  validates :subtotal,      numericality: { greater_than_or_equal_to: 0.00 }

  # manually tested :)
  scope :for_shift, -> (current_time = Time.zone.now) do
    config = Configuration.last_set
    time_opens_today = Time.new(current_time.year, current_time.month, current_time.day,
                                config.time_opens.hour, config.time_opens.min, 0, 0)
    time_from = current_time >= time_opens_today ? time_opens_today : time_opens_today - 1.day
    time_to   = current_time >= time_opens_today ? time_opens_today + 1.day : time_opens_today

    where({ created_at: time_from..time_to }).order(created_at: :desc)
  end

  def self.calculate_total_for_shift(datetime = Time.zone.now)
    bills = Bill.for_shift.includes([ :discount, { bill_items: :good } ])
    bills.select(&:closed?).inject(0) { |total, bill| total += bill.calculate_total }
  end

  def status
    return :cancelled if self.time_cancel
    return :closed    if self.time_close
    :open
  end

  def closed?
    self.time_close.present?
  end

  def cancelled?
    self.time_cancel.present?
  end

  def calculate_subtotal
    bill_items.inject(0) { |total, item| total += item.good.price * item.quantity }
  end

  def calculate_total
    calculate_subtotal * (100 - self.discount.value) / 100
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
