class Shift < ApplicationRecord
  has_many :bills
  has_many :spendings
  has_many :user_shifts
  has_many :users, through: :user_shifts

  default_scope { order(opened_at: :desc) }

  def closed?
    self.closed_at.present?
  end

  def status
    return :closed if closed?
    :open
  end

  def calculate_total_revenue
    (self.bills.inject(0) { |total, bill| bill.status == :closed ? total + bill.total : total }).round(2)
  end

  def calculate_total_spendings
    (self.spendings.inject(0) { |total, spending| spending.status == :added ? total + spending.total : total }).round(2)
  end

  def calculate_total
    calculate_total_revenue - calculate_total_spendings
  end

  def users_list
    self.users.map(&:name).join(", ")
  end

  def close(datetime = Time.zone.now)
    self.closed_at = datetime
    self.total_revenue = calculate_total_revenue
    self.total_spendings = calculate_total_spendings
    self.total = self.total_revenue - self.total_spendings
  end

  protected

  def self.current_day_range(datetime = Time.zone.now)
    config = Configuration.last_set
    time_opens_today = Time.new(datetime.year, datetime.month, datetime.day,
                                config.time_opens.hour, config.time_opens.min, 0, 0)
    time_from = datetime >= time_opens_today ? time_opens_today : time_opens_today - 1.day
    time_to   = datetime >= time_opens_today ? time_opens_today + 1.day : time_opens_today

    time_from..time_to
  end
end
