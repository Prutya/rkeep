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
    return :cancelled if time_cancel
    return :closed    if time_close
    :open
  end

  def close
    self.time_close = Time.zone.now
  end

  def cancel
    self.time_cancel = Time.zone.now
  end
end
