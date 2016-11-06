class Configuration < ApplicationRecord
  validates :company_name, presence: true, allow_blank: false
end
