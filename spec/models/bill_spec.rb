require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'relationships' do
    it { should belong_to :table }
    it { should have_many :bill_items }
  end

  describe 'validations' do
    it { should validate_presence_of :people_number }
    it { should validate_numericality_of(:people_number) }
    it { should_not allow_value(-1).for(:people_number) }
    it { should_not allow_value(0).for(:people_number) }
    it { should allow_value(1).for(:people_number) }
  end
end
