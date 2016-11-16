require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe 'relationships' do
    it { should have_many :bills }
    it { should have_many :spendings }
    it { should have_many :user_shifts }
    it { should have_many(:users).through(:user_shifts) }
  end

  describe 'validations' do
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
