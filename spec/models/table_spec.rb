require 'rails_helper'

RSpec.describe Table, type: :model do
  describe 'relationships' do
    it { should have_many :bills }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should_not allow_value("").for :name }
  end
end
