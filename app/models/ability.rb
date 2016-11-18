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

      can [:show, :destroy], Shift do |shift|
        user.at_shift?(shift)
      end

      can [:update, :create, :show, :destroy], Bill do |bill|
        user.at_shift?(bill.shift) && !bill.shift.closed?
      end

      can [:create, :destroy], Spending do |spending|
        user.at_shift?(spending.shift) && !spending.shift.closed?
      end

      can [:create], UserShift do |user_shift|
        user.at_shift?(user_shift.shift)
      end
    end

    if user.admin?
      can [:index, :show], Shift

      can [:show], Bill
    end
  end
end
