class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:index], :home

    if user.employee?
      can [:index, :create], Bill
    end
  end
end
