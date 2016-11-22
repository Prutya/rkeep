require 'rails_helper'

RSpec.describe UserShift, type: :model do
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :shift }
  end
end
