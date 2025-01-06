# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def edit_roles?
    user.admin?
  end

  def update_roles?
    user.admin?
  end

  def edit_assigned_users?
    user.admin? && record.full_access_roles_can?
  end

  def update_assigned_users?
    user.admin? && record.full_access_roles_can?
  end

  def switch_user
    user.full_access_roles_can?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
