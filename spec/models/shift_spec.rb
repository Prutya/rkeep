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
    end

    describe 'calculate total revenue' do

    end

    describe 'calculate total spendings' do

    end

    describe 'calculate total' do

    end
  end
end
