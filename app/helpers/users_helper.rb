# frozen_string_literal: true

module UsersHelper
  def get_user_roles_list_as_string(user)
    user.user_roles_names.map { |name| User::Roles::ROLES_MAP[name.to_sym] }.join(', ')
  end

  def get_user_role_ids_list(user)
    user.user_roles_names
  end
end
