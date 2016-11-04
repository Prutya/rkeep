require 'rails_helper'

RSpec.describe Good, type: :model do
  describe 'relationships' do
    it { should have_many :bill_items }
  end

  describe 'validations' do
    it { should validate_presence_of :name}
    it { should_not allow_value("").for :name }
    it { should validate_presence_of :price }
  end
end
