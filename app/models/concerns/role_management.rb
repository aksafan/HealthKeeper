# frozen_string_literal: true

module RoleManagement
  extend ActiveSupport::Concern

  included do
    after_commit :assign_default_role, on: :create
  end

  def user_roles_names
    roles.pluck(:name)
  end

  def update_roles?(new_roles)
    self.class.transaction do
      synchronize_roles(new_roles)

      raise ActiveRecord::Rollback unless errors.empty?
    rescue StandardError => e
      handle_unexpected_transaction_error(e)

      raise ActiveRecord::Rollback
    end
    are_errors_empty = errors.empty?

    unless are_errors_empty
      Rails.logger.error("Role update failed for Account ID #{id}: #{errors.full_messages.join(', ')}")
    end

    are_errors_empty
  end

  def full_access_roles_can?
    has_any_role?(*Role::FULL_ACCESS_ROLES)
  end

  def all_roles_can?
    has_any_role?(*Role::ROLES)
  end

  def admin?
    has_role?(Role::ADMIN)
  end

  def doctor?
    has_role?(Role::DOCTOR)
  end

  def health_coach?
    has_role?(Role::HEALTH_COACH)
  end

  def user?
    has_role?(Role::USER)
  end

  private

  def assign_default_role
    default_role = Role.find_or_create_by!(name: Role::USER)
    add_role(default_role.name) if roles.blank?
  end

  def synchronize_roles(new_roles)
    return unless validate_roles(new_roles)

    remove_roles(new_roles)
    add_roles(new_roles)
  end

  def add_roles(new_roles)
    roles_to_add = new_roles - user_roles_names
    roles_to_add.each { add_role(_1) || errors.add(:base, t('errors.messages.add_role_failure', role: role)) }
  end

  def remove_roles(new_roles)
    roles_to_remove = user_roles_names - new_roles
    roles_to_remove.each { remove_role(_1) || errors.add(:base, t('errors.messages.remove_role_failure', role: role)) }
  end

  def validate_roles(new_roles)
    if new_roles.empty?
      errors.add(:base, t('errors.messages.empty_roles_detected'))

      return false
    end

    valid_roles = Role.pluck(:name)
    invalid_roles = new_roles - valid_roles
    unless invalid_roles.empty?
      errors.add(:base, t('errors.messages.invalid_roles_detected', invalid_roles: invalid_roles.join(', ')))
    end

    invalid_roles.empty?
  end
end
