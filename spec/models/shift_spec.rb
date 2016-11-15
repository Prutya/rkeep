require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe 'relationships' do
    it { should have_many :bills }
    it { should have_many :spendings }
    it { should have_many :user_shifts }
    it { should have_many(:users).through(:user_shifts) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:total) }
    it { should_not allow_value(-1).for(:total) }
    it { should allow_value(0.00).for(:total) }
    it { should allow_value(1.00).for(:total) }

    it { should validate_numericality_of(:subtotal) }
    it { should_not allow_value(-1).for(:subtotal) }
    it { should allow_value(0.00).for(:subtotal) }
    it { should allow_value(1.00).for(:subtotal) }
  end
end
