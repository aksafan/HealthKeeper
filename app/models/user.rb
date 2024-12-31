# frozen_string_literal: true

class User < ApplicationRecord
  include ActionView::Helpers::TranslationHelper

  rolify
  resourcify
  after_commit :assign_default_role, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :health_records, dependent: :destroy
  has_many :lab_tests, dependent: :destroy
  has_many :measurements, dependent: :destroy

  has_and_belongs_to_many :roles, join_table: :users_roles # rubocop:disable Rails/HasAndBelongsToMany

  # As an assignee (doctor/health_coach) having multiple assigned users (clients)
  # Uses Self Joins @see https://guides.rubyonrails.org/association_basics.html#self-joins
  has_many :assigned_relationships,
           class_name: 'Assignment',
           foreign_key: 'assignee_id',
           dependent: :destroy,
           inverse_of: :assignee
  has_many :assigned_users, through: :assigned_relationships, source: :assigned

  # As an assigned user (client) possibly having multiple assignees (doctor/health_coach)
  # Uses Self Joins @see https://guides.rubyonrails.org/association_basics.html#self-joins
  has_many :assignee_relationships,
           class_name: 'Assignment',
           foreign_key: 'assigned_id',
           dependent: :destroy,
           inverse_of: :assigned
  has_many :assignees, through: :assignee_relationships, source: :assignee

  accepts_nested_attributes_for :roles

  validates :email, presence: true, uniqueness: true, email: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def user_roles_names
    roles.pluck(:name)
  end

  def assigned_users_names
    assigned_users.pluck(:first_name, :last_name)
  end

  def assigned_users_ids
    assigned_users.pluck(:id)
  end

  def full_access_roles_can?
    has_any_role?(*Roles::FULL_ACCESS_ROLES)
  end

  def all_roles_can?
    has_any_role?(*Roles::ROLES)
  end

  def admin?
    has_role?(Roles::ADMIN)
  end

  def doctor?
    has_role?(Roles::DOCTOR)
  end

  def health_coach?
    has_role?(Roles::HEALTH_COACH)
  end

  def user?
    has_role?(Roles::USER)
  end

  def update_roles?(new_roles)
    User.transaction do
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

  def assign_default_role
    add_role(Roles::USER) if roles.blank?
  end

  def synchronize_roles(new_roles)
    return unless validate_roles(new_roles)

    remove_roles(new_roles)
    add_roles(new_roles)
  end

  def add_roles(new_roles)
    roles_to_add = new_roles - user_roles_names
    roles_to_add.each do |role|
      add_role(role) || errors.add(:base, t('errors.messages.add_role_failure', role: role))
    end
  end

  def remove_roles(new_roles)
    roles_to_remove = user_roles_names - new_roles
    roles_to_remove.each do |role|
      remove_role(role) || errors.add(:base, t('errors.messages.remove_role_failure', role: role))
    end
  end

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

  def validate_roles(new_roles)
    valid_roles = Role.pluck(:name)
    invalid_roles = new_roles - valid_roles
    unless invalid_roles.empty?
      errors.add(:base, t('errors.messages.invalid_roles_detected', invalid_roles: invalid_roles.join(', ')))
    end

    invalid_roles.empty?
  end

  def handle_unexpected_transaction_error(error)
    errors.add(:base, t('errors.messages.unexpected_error'))
    Rails.logger.error("Unexpected error while doing transaction: #{error.message}")
  end

  class Roles < User
    ADMIN = :admin
    DOCTOR = :doctor
    HEALTH_COACH = :health_coach
    USER = :user

    ROLES = [ADMIN, DOCTOR, HEALTH_COACH, USER].freeze
    FULL_ACCESS_ROLES = [ADMIN, DOCTOR, HEALTH_COACH].freeze

    ROLES_MAP = {
      ADMIN => 'Admin',
      DOCTOR => 'Doctor',
      HEALTH_COACH => 'Health coach',
      USER => 'User'
    }.freeze
  end
end
