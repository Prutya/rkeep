require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationships' do
    it { should have_many :bills }
  end

  describe 'validations' do
    it { should validate_numericality_of(:value) }
    it { should_not allow_value(-1).for(:value) }
    it { should allow_value(0.00).for(:value) }
    it { should allow_value(1.00).for(:value) }
    it { should allow_value(100.00).for(:value) }
    it { should_not allow_value(100.01).for(:value) }
  end
end
