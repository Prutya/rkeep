require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many :assignments }
    it { should have_many :bill_items }
    it { should have_many :spendings }
    it { should have_many(:roles).through(:assignments) }
  end

  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should_not allow_value("").for :first_name }
    it { should validate_presence_of :last_name }
    it { should_not allow_value("").for :last_name }
    it { should validate_presence_of :phone }
    it { should_not allow_value("").for :phone }
  end
end
