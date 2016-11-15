class Spending < ApplicationRecord
  belongs_to :shift

  validates :name, presence: true, allow_blank: false
  validates :total, presence: true, numericality: { greater_than: 0.00 }

  def status
    return :cancelled if self.time_cancel
    :ok
  end

  def cancelled?
    self.time_cancel.present?
  end

  def cancel(cancel_time = Time.zone.now)
    self.time_cancel = cancel_time
  end
end
