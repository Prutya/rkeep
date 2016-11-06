require 'rails_helper'

RSpec.describe Role, type: :model do
  context 'relationships' do
    it { should have_many :assignments }
    it { should have_many(:users).through(:assignments) }
  end

  describe 'validations' do
    subject { FactoryGirl.build(:role) }
    it { should validate_uniqueness_of :name }
    it { should_not allow_value("").for :name }
  end
end
