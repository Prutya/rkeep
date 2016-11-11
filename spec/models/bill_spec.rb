require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'relationships' do
    it { should belong_to :table }
    it { should belong_to :user }
    it { should belong_to :discount }
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
  end

  describe 'methods' do
    before(:each) do
      @current_time = Time.zone.now
    end

    describe 'self' do
      before(:each) do
        Configuration.create({ time_opens: @current_time })
      end

      describe 'calculate_total_for_shift' do
        context 'no bills' do
          it 'should be zero' do
            expect(Bill.calculate_total_for_shift(@current_time)).to be_zero
          end
        end

        context 'with bills' do
          before(:each) do
            @table = Table.create({ name: 'Table1' })
            @good = Good.create({ name: 'Good1', price: 100.00 })
            @discount = Discount.create({ value: 10.00 })
            @bills = [ Bill.create({ discount: @discount, table: @table }),
                       Bill.create({ discount: @discount, table: @table }),
                       Bill.create({ discount: @discount, table: @table }) ]
            @bills.each do |bill| bill.bill_items << BillItem.new({ good: @good, quantity: 1 }) end
          end

          context 'all cancelled bills' do
            it 'should return zero' do
              @bills.each do |bill| bill.cancel; bill.save! end

              expect(Bill.calculate_total_for_shift(@current_time)).to be_zero
            end
          end

          context 'all closed bills' do
            it 'should return correct value' do
              @bills.each do |bill| bill.close; bill.save! end

              expect(Bill.calculate_total_for_shift(@current_time)).to eq 270.00
            end
          end

          context 'all new bills' do
            it 'should return zero' do
              expect(Bill.calculate_total_for_shift(@current_time)).to be_zero
            end
          end

          context 'mixed bills' do
            it 'should return correct value' do
              @bills[0].cancel; @bills[0].save!
              @bills[1].close; @bills[1].save!

              expect(Bill.calculate_total_for_shift(@current_time)).to eq 90.00
            end
          end
        end
      end
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
