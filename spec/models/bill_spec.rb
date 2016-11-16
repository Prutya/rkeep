require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'relationships' do
    it { should belong_to :table }
    it { should belong_to :shift }
    it { should belong_to :discount }
    it { should have_many :bill_items }
  end

  describe 'validations' do
    it { should validate_presence_of :people_number }
    it { should validate_numericality_of(:people_number) }
    it { should_not allow_value(-1).for(:people_number) }
    it { should_not allow_value(0).for(:people_number) }
    it { should allow_value(1).for(:people_number) }
  end

  describe 'methods' do
    before(:each) do
      @current_time = Time.zone.now
    end

    describe 'close' do
      before(:each) do
        subject.discount = Discount.create({ value: 10.00 })
      end

      it 'sets time_close' do
        subject.close(@current_time)

        expect(subject.time_close).to eq @current_time
      end

      it 'updates total' do
        subject.close(@current_time)

        expect(subject.total).to eq subject.calculate_total
      end

      it 'update subtotal' do
        subject.close(@current_time)

        expect(subject.subtotal).to eq subject.calculate_subtotal
      end
    end

    describe 'cancel' do
      it 'sets time_cancel' do
        subject.cancel(@current_time)

        expect(subject.time_cancel).to eq @current_time
      end
    end

    describe 'calculations' do
      before(:each) do
        @discounts = [ Discount.new({ value: 50.00 }) ]
        [ Good.new({ name: 'Good1', price: 100.00 }), Good.new({ name: 'Good2', price: 200.00 }) ].each do |good|
          subject.bill_items.push(BillItem.new({ good: good, quantity: 2 }))
        end
      end

      describe 'subtotal' do
        it 'should return correct subtotal' do
          expect(subject.calculate_subtotal).to eq 600.00
        end
      end

      describe 'total' do
        context 'without discount' do
          it 'should return correct total' do
            expect(subject.calculate_subtotal).to eq 600.00
          end
        end

        context 'with discount' do
          it 'should return correct total' do
            subject.discount = @discounts[0]

            expect(subject.calculate_total).to eq 300.00
          end
        end
      end
    end
  end

  describe 'helpers' do
    before(:each) do
      subject.discount = Discount.create({ value: 10.00 })
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

    describe 'closed?' do
      it 'returns true if bill is closed' do
        subject.close

        expect(subject.closed?).to be_truthy
      end

      it 'returns false if bill is not closed' do
        expect(subject.closed?).to be_falsy
      end
    end

    describe 'cancelled?' do
      it 'returns true if bill is cancelled' do
        subject.cancel

        expect(subject.cancelled?).to be_truthy
      end

      it 'returns false if bill is not cancelled' do
        expect(subject.cancelled?).to be_falsy
      end
    end
  end
end
