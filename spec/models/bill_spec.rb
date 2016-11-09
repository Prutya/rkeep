require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'relationships' do
    it { should belong_to :table }
    it { should belong_to :user }
    it { should have_many :bill_items }
  end

  describe 'validations' do
    it { should validate_presence_of :people_number }

    it { should validate_numericality_of(:people_number) }
    it { should_not allow_value(-1).for(:people_number) }
    it { should_not allow_value(0).for(:people_number) }
    it { should allow_value(1).for(:people_number) }

    it { should validate_numericality_of(:total) }
    it { should_not allow_value(-1).for(:total) }
    it { should allow_value(0.00).for(:total) }
    it { should allow_value(1.00).for(:total) }

    it { should validate_numericality_of(:subtotal) }
    it { should_not allow_value(-1).for(:subtotal) }
    it { should allow_value(0.00).for(:subtotal) }
    it { should allow_value(1.00).for(:subtotal) }

    it { should validate_numericality_of(:discount) }
    it { should_not allow_value(-1).for(:discount) }
    it { should allow_value(0.00).for(:discount) }
    it { should allow_value(1.00).for(:discount) }
    it { should allow_value(100.00).for(:discount) }
    it { should_not allow_value(100.01).for(:discount) }
  end

  describe 'methods' do
    before(:each) do
      @current_time = Time.zone.now
    end

    describe 'close' do
      it 'sets time_close' do
        subject.close(@current_time)
        expect(subject.time_close).to eq @current_time
      end
    end

    describe 'cancel' do
      it 'sets time_cancel' do
        subject.cancel(@current_time)
        expect(subject.time_cancel).to eq @current_time
      end
    end

    describe 'status' do
      context 'when bill has time_close and time_cancel' do
        it 'returns status cancel' do
          subject.close
          subject.cancel
          expect(subject.status).to eq :cancelled
        end
      end

      context 'when bill has only time_cancel' do
        it 'returns status cancelled' do
          subject.cancel
          expect(subject.status).to eq :cancelled
        end
      end

      context 'when bill has only time_close' do
        it 'returns status closed' do
          subject.close
          expect(subject.status).to eq :closed
        end
      end

      context 'any other state' do
        it 'returns status closed' do
          expect(subject.status).to eq :open
        end
      end
    end

    describe 'calculations' do
      before(:each) do
        [ Good.new({ name: 'Good1', price: 100.00 }), Good.new({ name: 'Good2', price: 200.00 }) ].each do |good|
          subject.bill_items.push(BillItem.new({ good: good, quantity: 2 }))
        end
      end

      describe 'subtotal' do
        it 'should return correct subtotal' do
          expect(subject.calculate_subtotal).to eq 600.00
        end
      end

      describe 'total without discount' do
        it 'should return correct total' do
          expect(subject.calculate_subtotal).to eq 600.00
        end
      end

      describe 'total with discount' do
        it 'should return correct total' do
          subject.discount = 50.00
          expect(subject.calculate_total).to eq 300.00
        end
      end
    end
  end
end
