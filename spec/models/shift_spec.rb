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

  describe 'methods' do
    describe 'close' do
      before(:each) do
        subject.close
      end

      it 'should set closed_at' do
        expect(subject.closed_at).to be
      end

      it 'should set total_revenue' do
        expect(subject.total_revenue).to be
      end

      it 'should set total_spendings' do
        expect(subject.total_spendings).to be
      end

      it 'shoulf set total' do
        expect(subject.total).to be
      end
    end
  end

  describe 'calculations' do
    before(:each) do
      @shift = create(:shift)
      @bills = create_list(:bill, 4, total: 200.00)
      @spendings = create_list(:spending, 4, total: 20.00)
      @shift.bills.each { |b| b.time_close = Time.zone.now }

      @shift.spendings << @spendings
      @shift.bills << @bills
    end

    describe 'calculate total revenue' do
      before(:each) do
        @shift.bills.each { |b| b.time_close = Time.zone.now }
      end

      context 'when all bills are closed' do
        it 'should return correct value' do
          expect(@shift.calculate_total_revenue).to eq 800.00
        end
      end

      context 'when some bills are cancelled' do
        before(:each) do
          @shift.bills.first.time_cancel = Time.zone.now
        end

        it 'should return correct value' do
          expect(@shift.calculate_total_revenue).to eq 600.00
        end
      end

      context 'when some bills are open' do
        before(:each) do
          @shift.bills.first.time_close = nil
        end

        it 'should return correct value' do
          expect(@shift.calculate_total_revenue).to eq 600.00
        end
      end
    end

    describe 'calculate total spendings' do
      context 'when all spendings are not cancelled' do
        it 'should return correct value' do
          expect(@shift.calculate_total_spendings).to eq 80.00
        end
      end
    end

    describe 'calculate total' do
      before(:each) do
        @shift.bills.each { |b| b.time_close = Time.zone.now }
      end

      it 'should return correct value' do
        expect(@shift.calculate_total).to eq 720.00
      end
    end
  end
end
