require 'rails_helper'

RSpec.describe Configuration, type: :model do
  describe 'validations' do
    subject { FactoryGirl.build(:configuration) }
    it { should validate_presence_of :time_opens }
    it { should_not allow_value("").for :company_name }
  end
end
