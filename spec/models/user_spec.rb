require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many :assignments }
    it { should have_many :bills }
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

    describe 'roles' do
      context 'admin?' do
        it 'should return true when has admin role' do
          subject.roles << @roles[0]
          expect(subject.admin?).to be_truthy
        end
        it 'should return false when has no admin role' do
          expect(subject.admin?).to be_falsy
        end
      end

      context 'employee?' do
        it 'should return true when has employee role' do
          subject.roles << @roles[1]
          expect(subject.employee?).to be_truthy
        end
        it 'should return false when has no employee role' do
          expect(subject.employee?).to be_falsy
        end
      end
    end

    describe 'helper' do
      context 'name' do
        it 'should return full name' do
          expect(subject.name).to eq "#{subject.first_name} #{subject.last_name}"
        end
      end
    end
  end

  describe 'abilities' do
    describe 'guest' do
      it 'should have access to home page' do
        @ability = Ability.new(subject)
        expect(@ability.can?(:index, :home)).to be_truthy
      end
    end

    describe 'rails admin' do
      it 'should not have access to rails admin' do
        @ability = AdminAbility.new(subject)
        expect(@ability.can?(:access, :rails_admin)).to be_falsy
      end

      it 'should have access to rails admin if is admin' do
        subject.roles << Role.new({ name: :admin })
        @ability = AdminAbility.new(subject)
        expect(@ability.can?(:access, :rails_admin)).to be_truthy
      end
    end
  end
end
