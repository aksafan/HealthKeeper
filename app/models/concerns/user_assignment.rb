# frozen_string_literal: true

module UserAssignment
  extend ActiveSupport::Concern

  included do
    # As an assignee (doctor/health_coach) having multiple assigned users (clients)
    # Uses Self Joins @see https://guides.rubyonrails.org/association_basics.html#self-joins
    has_many :assigned_relationships,
             class_name: 'Assignment',
             foreign_key: 'assignee_id',
             dependent: :destroy,
             inverse_of: :assignee
    has_many :assigned_users,
             through: :assigned_relationships,
             source: :assigned

    # As an assigned user (client) possibly having multiple assignees (doctor/health_coach)
    # Uses Self Joins @see https://guides.rubyonrails.org/association_basics.html#self-joins
    has_many :assignee_relationships,
             class_name: 'Assignment',
             foreign_key: 'assigned_id',
             dependent: :destroy,
             inverse_of: :assigned
    has_many :assignees,
             through: :assignee_relationships,
             source: :assignee
  end

  def assigned_users_names
    assigned_users.pluck(:first_name, :last_name)
  end

  def assigned_users_ids
    assigned_users.pluck(:id)
  end

  def assign_users?(new_user_ids)
    User.transaction do
      synchronize_assignments(new_user_ids)

      raise ActiveRecord::Rollback unless errors.empty?
    rescue StandardError => e
      handle_unexpected_transaction_error(e)

      raise ActiveRecord::Rollback
    end
    are_errors_empty = errors.empty?

    unless are_errors_empty
      Rails.logger.error("User assignment failed for Account ID #{id}: #{errors.full_messages.join(', ')}")
    end

    are_errors_empty
  end

  private

  def synchronize_assignments(new_user_ids)
    remove_assigned_users(new_user_ids)
    assign_users(new_user_ids)
  end

  def assign_users(new_user_ids)
    user_ids_to_add = new_user_ids - assigned_users_ids
    user_ids_to_add.each do |id|
      (assigned_users << User.find(id)) || errors.add(:base, t('errors.messages.add_user_assignment_failure', id: id))
    end
  end

  def remove_assigned_users(new_user_ids)
    user_ids_to_remove = assigned_users_ids - new_user_ids
    user_ids_to_remove.each do |id|
      assigned_users.delete(id) || errors.add(:base, t('errors.messages.remove_user_assignment_failure', id: id))
    end
  end
end
