class Configuration < ApplicationRecord
  def self.last_set
    order(time_setup: :desc).first
  end
end
