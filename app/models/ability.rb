class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new

    can :show, Hack
    can :home, Event
    can [:show, :order], Event, :hidden => false
    
    unless user.id.nil?
      can [:create, :join], Hack
      can [:edit, :update, :submit], Hack do |hack|
        hack.confirmed_member_ids.include?(user.id) && !hack.submitted?
      end
      can :destroy, Hack do |hack|
        hack.confirmed_member_ids.include?(user.id)
      end
      can :show, Hack, :event => {:hidden => false}
      can [:like, :unlike], Hack
    end

    case user.role
      when 'admin'
        can :manage, :all
      when 'manager'
        can :raffle, Event
        can :shuffle, Event
        can :manage, Hack
    end
  end
end
