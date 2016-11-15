class Spending < ApplicationRecord
  belongs_to :shift

  validates :name, presence: true, allow_blank: false
  validates :total, presence: true, numericality: { greater_than: 0.00 }

  scope :for_shift, -> (datetime = Time.zone.now) do
    where({ created_at: get_current_day_range(datetime) }).order(created_at: :desc)
  end

  def self.calculate_total_for_shift(datetime = Time.zone.now)
    where({ created_at: get_current_day_range(datetime) }).where({ time_cancel: nil }).sum(:total)
  end

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

  protected

  def self.get_current_day_range(datetime)
    config = Configuration.last_set
    time_opens_today = Time.new(datetime.year, datetime.month, datetime.day,
                                config.time_opens.hour, config.time_opens.min, 0, 0)
    time_from = datetime >= time_opens_today ? time_opens_today : time_opens_today - 1.day
    time_to   = datetime >= time_opens_today ? time_opens_today + 1.day : time_opens_today

    time_from..time_to
  end
end
