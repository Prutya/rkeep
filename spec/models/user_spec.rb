require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many :assignments }
    it { should have_many :bill_items }
    it { should have_many :spendings }
    it { should have_many(:roles).through(:assignments) }
  end
end
