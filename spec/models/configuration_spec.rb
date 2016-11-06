require 'rails_helper'

RSpec.describe Configuration, type: :model do
  describe 'methods' do
    it 'should return last config' do
      configurations = [ Configuration.create,
                         Configuration.create({ time_setup: Time.zone.now + 1.day }) ]
      expect(Configuration.last_set).to eq configurations[1]
    end
  end
end
