require 'rails_helper'

RSpec.describe BillItem, type: :model do
  describe 'relationships' do
    it { should belong_to :good }
    it { should belong_to :bill }
  end

  describe 'validations' do
    it { should validate_numericality_of :quantity }
    it { should_not allow_value(-1).for(:quantity) }
    it { should_not allow_value(0).for(:quantity) }
    it { should allow_value(1).for(:quantity) }
  end

  describe 'methods' do
    describe 'calculate_subtotal' do
      before(:each) do
        good = Good.new({ name: 'Test1', price: 20.00 })
        subject.good = good
      end

      it 'should return correct value' do
        subject.quantity = 10

        expect(subject.calculate_subtotal).to eq 200.00
      end
    end
  end
end
