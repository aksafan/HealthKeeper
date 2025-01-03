# frozen_string_literal: true

module UsersHelper
  def user_roles_list_as_string(user)
    user.user_roles_names.map { Role::ROLES_MAP[_1.to_sym] }.join(', ')
  end

  def assigned_user_list_as_string(user)
    user.assigned_users.map(&:full_name).join(', ')
  end

  def assigned?(user)
    !user.assigned_users.empty?
  end

  def assignees?(user)
    !user.assignees.empty?
  end

  def assignees_list_as_string(user)
    user.assignees.map(&:full_name).join(', ')
  end

  def user_role_names_list(user)
    user.user_roles_names
  end

  def assigned_user_ids_list(user)
    user.assigned_users_ids
  end

  def assigned_users_list_for_select(user)
    user.assigned_users.map { [_1.full_name, _1.id] }
  end

  def users_list_for_select(user)
    user.users_list.map { [_1.full_name, _1.id] }
  end
end
