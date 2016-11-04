require 'rails_helper'

RSpec.describe Good, type: :model do
  describe 'relationships' do
    it { should have_many :bill_items }
  end
end
