class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:index], :home

    if user.employee?
      can [:index, :create, :show, :destroy], Shift
      can [:index, :update, :create, :show, :destroy], Bill
      can [:index, :create, :destroy], Spending
      can [:index, :create], UserShift
    end
  end
end
