class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:index], :home

    if user.employee?
      can [:index, :create, :show, :update, :destroy], Bill
      can [:index, :create, :destroy], Spending
    end
  end
end
