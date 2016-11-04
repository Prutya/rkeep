require 'rails_helper'

RSpec.describe BillItem, type: :model do
  describe 'relationships' do
    it { should belong_to :good }
    it { should belong_to :bill }
    it { should belong_to :user }
  end
end
