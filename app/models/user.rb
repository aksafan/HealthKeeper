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

  accepts_nested_attributes_for :roles

  validates :email, presence: true, uniqueness: true, email: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def user_roles_names
    roles.pluck(:name)
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

  private

  def assign_default_role
    add_role(Roles::USER) if roles.blank?
  end

  def synchronize_roles(new_roles)
    return unless validate_roles(new_roles)

    current_roles = roles.pluck(:name)

    roles_to_remove = current_roles - new_roles
    roles_to_remove.each do |role|
      remove_role(role) || errors.add(:base, t('errors.messages.remove_role_failure', role: 'role'))
    end

    roles_to_add = new_roles - current_roles
    roles_to_add.each do |role|
      add_role(role) || errors.add(:base, t('errors.messages.add_role_failure', role: 'role'))
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
    Rails.logger.error("Unexpected error while synchronizing roles: #{error.message}")
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
