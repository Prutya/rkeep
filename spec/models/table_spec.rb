require 'rails_helper'

RSpec.describe Table, type: :model do
  describe 'relationships' do
    it { should have_many :bills }
  end
end
