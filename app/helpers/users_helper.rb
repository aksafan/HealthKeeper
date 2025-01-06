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

  # @param [Object] user The user to check for assigned users
  # @param [Object] current_user The current logged in user to add to a list of assigned users

  # @return [[string, int]] Pairs of user full name and id ready to use in select field
  # Adds current user pair if it was not selected - TODO: rethought/rewrite this to make behavior more consistent
  # Or empty array if there are no assigned users
  def assigned_users_list_for_select(user, current_user)
    return [] if user.assigned_users.empty?

    current_user_included = false
    assigned_users = user.assigned_users.map do |assigned_user|
      current_user_included = true if assigned_user.id == current_user.id
      [assigned_user.full_name, assigned_user.id]
    end

    assigned_users << [current_user.full_name, current_user.id] unless current_user_included

    assigned_users
  end

  def users_list_for_select(user)
    user.users_list.map { [_1.full_name, _1.id] }
  end

  def assigned_users?
    current_user.full_access_roles_can? && !current_user.assigned_users.empty?
  end
end
