require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'relationships' do
    it { should belong_to :table }
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
  end
end
