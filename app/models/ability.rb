class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin?
        can :manage, :all
      else
        can :view, Customer
#        can :manage, Employee, id: user.employee.id
      end
    end
  end
end
