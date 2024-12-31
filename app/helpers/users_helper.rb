# frozen_string_literal: true

module UsersHelper
  def get_user_roles_list_as_string(user)
    user.user_roles_names.map { User::Roles::ROLES_MAP[_1.to_sym] }.join(', ')
  end

  def get_assigned_user_list_as_string(user)
    user.assigned_users.map(&:full_name).join(', ')
  end

  def get_user_role_ids_list(user)
    user.user_roles_names
  end

  def get_assigned_user_ids_list(user)
    user.assigned_users_ids
  end
end
