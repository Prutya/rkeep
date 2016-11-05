require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many :assignments }
    it { should have_many :bill_items }
    it { should have_many :spendings }
    it { should have_many(:roles).through(:assignments) }
  end

  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should_not allow_value("").for :first_name }
    it { should validate_presence_of :last_name }
    it { should_not allow_value("").for :last_name }
    it { should validate_presence_of :phone }
    it { should_not allow_value("").for :phone }
  end

  describe 'methods' do
    before(:all) do
      @roles = [ Role.new({ name: :admin }), Role.new({ name: :employee }) ]
    end

    describe 'admin?' do
      it 'should return true when has admin role' do
        subject.roles << @roles[0]
        expect(subject.admin?).to be_truthy
      end
      it 'should return false when has no admin role' do
        expect(subject.admin?).to be_falsy
      end
    end

    describe 'employee?' do
      it 'should return true when has employee role' do
        subject.roles << @roles[1]
        expect(subject.employee?).to be_truthy
      end
      it 'should return false when has no employee role' do
        expect(subject.employee?).to be_falsy
      end
    end
  end

  describe 'abilities' do
    describe 'rails admin' do
      before(:each) do
        @ability = AdminAbility.new(subject)
      end

      it 'should not be able to access rails admin' do
        @ability.should_not be_able_to :access, :rails_admin
      end

      it 'should be able to access rails admin if is admin' do
        subject.roles << Role.new({ name: :admin })
        @ability = AdminAbility.new(subject)
        @ability.should be_able_to :access, :rails_admin
      end
    end
  end
end
