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

    it { should validate_numericality_of(:total_revenue) }
    it { should_not allow_value(-1).for(:total_revenue) }
    it { should allow_value(0.00).for(:total_revenue) }
    it { should allow_value(1.00).for(:total_revenue) }

    it { should validate_numericality_of(:total_spendings) }
    it { should_not allow_value(-1).for(:total_spendings) }
    it { should allow_value(0.00).for(:total_spendings) }
    it { should allow_value(1.00).for(:total_spendings) }
  end

  describe 'calculations' do
    before(:each) do
      @discounts = [ Discount.new({ value: 50.00 }) ]
      [ Good.new({ name: 'Good1', price: 100.00 }), Good.new({ name: 'Good2', price: 200.00 }) ].each do |good|
        subject.bill_items.push(BillItem.new({ good: good, quantity: 2 }))
      end
    end
  end
end
