require 'rails_helper'

RSpec.describe Spending, type: :model do
  describe 'relationships' do
    it { should belong_to :shift }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should_not allow_value("").for :name }

    it { should validate_presence_of :total }
    it { should validate_numericality_of(:total) }
    it { should_not allow_value(-1).for(:total) }
    it { should_not allow_value(0.00).for(:total) }
    it { should allow_value(1.00).for(:total) }
  end

  describe 'methods' do
    before(:each) do
      @current_time = Time.zone.now
    end

    describe 'cancel' do
      it 'sets time_cancel' do
        subject.cancel(@current_time)

        expect(subject.time_cancel).to eq @current_time
      end
    end
  end

  describe 'helpers' do
    describe 'status' do
      context 'when bill has only time_cancel' do
        it 'returns status cancelled' do
          subject.cancel

          expect(subject.status).to eq :cancelled
        end
      end

      context 'any other state' do
        it 'returns status ok' do
          expect(subject.status).to eq :added
        end
      end
    end

    describe 'cancelled?' do
      it 'returns true if is cancelled' do
        subject.cancel

        expect(subject.cancelled?).to be_truthy
      end

      it 'returns false if is not cancelled' do
        expect(subject.cancelled?).to be_falsy
      end
    end
  end
end
