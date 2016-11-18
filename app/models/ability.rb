class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:index], :home

    if user.employee?
      can [:index], Shift

      unless Shift.any? { |s| s.closed_at.nil? }
        can [:create], Shift
      end

      can [:show, :update, :destroy], Shift do |shift|
        user.at_shift?(shift) && !shift.closed?
      end

      can [:update], Bill do |bill|
        can?(:update, bill.shift) && !bill.closed? && !bill.cancelled?
      end

      can [:create], UserShift do |user_shift|
        can?(:update, user_shift.shifts) && user_shift.user.employee? && !user_shift.user.busy?
      end
    end

    if user.admin?
      can [:index, :show], Shift

      can [:show], Bill
    end
  end
end
