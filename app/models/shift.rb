class Shift < ApplicationRecord
  has_many :bills, dependent: :nullify
  has_many :spendings, dependent: :nullify
  has_many :user_shifts, dependent: :destroy

  has_many :users, through: :user_shifts

  default_scope { order(opened_at: :desc).preload(:users) }

  def closed?
    self.closed_at.present?
  end

  def has_open_bills?
    self.bills.any? { |bill| bill.time_close.nil? && bill.time_cancel.nil? }
  end

  def next_bill_number
    bills.count + 1
  end

  def next_spending_number
    spendings.count + 1
  end

  def closed_bills_number
    bills.inject(0) { |total, bill| bill.status == :closed ? total += 1 : total }
  end

  def open_bills_number
    bills.inject(0) { |total, bill| bill.status == :open ? total += 1 : total }
  end

  def cancelled_bills_number
    bills.inject(0) { |total, bill| bill.status == :cancelled ? total += 1 : total }
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
end
