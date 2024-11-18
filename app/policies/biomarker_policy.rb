class BiomarkerPolicy < ApplicationPolicy
  def index?
    user.all_roles_can?
  end

  def show?
    user.all_roles_can?
  end

  def create?
    user.full_access_roles_can?
  end

  def update?
    user.full_access_roles_can?
  end

  def destroy?
    user.full_access_roles_can?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
