require 'rails_helper'

RSpec.describe Role, type: :model do
  context 'relationships' do
    it { should have_many :assignments }
    it { should have_many(:users).through(:assignments) }
  end
end
