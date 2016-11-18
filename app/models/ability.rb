class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:index], :home

    if user.employee?
      can [:index], Shift

      can [:create], Shift do |shift|
        Shift.any? { |s| s.closed_at.empty? }
      end

      can [:show, :update, :destroy], Shift do |shift|
        user.at_shift?(shift) && !shift.closed?
      end

      can [:update], Bill do |bill|
        can?(:update, bill.shift) && !bill.closed? && !bill.cancelled?
      end
    end

    if user.admin?
      can [:index, :show], Shift

      can [:show], Bill
    end
  end
end
