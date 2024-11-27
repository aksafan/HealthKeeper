# frozen_string_literal: true

class LabTestPolicy < ApplicationPolicy
  def index?
    user.all_roles_can?
  end

  def show?
    user.full_access_roles_can? || record.user == user
  end

  def create?
    user.all_roles_can?
  end

  def update?
    user.full_access_roles_can? || record.user == user
  end

  def destroy?
    user.full_access_roles_can? || record.user == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.full_access_roles_can?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
