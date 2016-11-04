require 'rails_helper'

RSpec.describe Spending, type: :model do
  describe 'relationships' do
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should_not allow_value("").for :name }
  end
end
