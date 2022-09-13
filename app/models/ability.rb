# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :super_admin
      can :manage, :all
      can :access, :all
    elsif user.has_role? :admin
      can :access, :admin_scope
      can :manage, :admin_scope
    elsif user.has_role? :asn
      can :manage, :self
      can :access, :self
    else
      can :manage, :none
      can :access, :none
    end
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
