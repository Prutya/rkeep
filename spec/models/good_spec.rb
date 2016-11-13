require 'rails_helper'

RSpec.describe Good, type: :model do
  describe 'relationships' do
    it { should have_many :bill_items }
  end

  describe 'validations' do
    it { should validate_presence_of :name}
    it { should_not allow_value("").for :name }

    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price) }
    it { should_not allow_value(-1).for(:price) }
    it { should_not allow_value(0.00).for(:price) }
    it { should allow_value(1.00).for(:price) }
  end
end
