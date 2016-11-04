require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'relationships' do
    it { should belong_to :table }
    it { should have_many :bill_items }
  end
end
