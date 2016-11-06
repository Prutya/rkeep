class Bill < ApplicationRecord
  belongs_to :table
  has_many   :bill_items

  validates :people_number, presence: true

  scope :for_shift, -> (current_time = nil) do
    current_time ||= Time.zone.now
    config = Configuration.last_set
    time_opens_today = Time.new(current_time.year, current_time.month, current_time.day,
                                config.time_opens.hour, config.time_opens.min, 0, 0)
    time_from = current_time >= time_opens_today ? time_opens_today : time_opens_today - 1.day
    time_to   = current_time >= time_opens_today ? time_opens_today + 1.day : time_opens_today

    where({ created_at: time_from..time_to })
  end
end
