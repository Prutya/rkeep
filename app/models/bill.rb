class Bill < ApplicationRecord
  belongs_to :table
  has_many   :bill_items

  validates :people_number, presence: true, numericality: { greater_than: 0 }

  # manually tested :)
  scope :for_shift, -> (current_time = Time.zone.now) do
    config = Configuration.last_set
    time_opens_today = Time.new(current_time.year, current_time.month, current_time.day,
                                config.time_opens.hour, config.time_opens.min, 0, 0)
    time_from = current_time >= time_opens_today ? time_opens_today : time_opens_today - 1.day
    time_to   = current_time >= time_opens_today ? time_opens_today + 1.day : time_opens_today

    where({ created_at: time_from..time_to }).order(created_at: :desc)
  end

  def status
    return :cancelled if self.time_cancel
    return :closed    if self.time_close
    :open
  end

  def close(close_time = Time.zone.now)
    self.time_close = close_time
  end

  def cancel(cancel_time = Time.zone.now)
    self.time_cancel = cancel_time
  end
end
