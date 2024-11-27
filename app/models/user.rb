# frozen_string_literal: true

class User < ApplicationRecord
  rolify role_join_table_name: 'users_roles'
  resourcify
  after_commit :assign_default_role, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :health_records, dependent: :destroy
  has_many :lab_tests, dependent: :destroy
  has_many :measurements, dependent: :destroy

  validates :email, presence: true, uniqueness: true, email: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_access_roles_can?
    has_any_role?(*User::Roles::FULL_ACCESS_ROLES)
  end

  def all_roles_can?
    has_any_role?(*User::Roles::ROLES)
  end

  def admin?
    has_role?(User::Roles::ADMIN)
  end

  def doctor?
    has_role?(User::Roles::DOCTOR)
  end

  def health_coach?
    has_role?(User::Roles::HEALTH_COACH)
  end

  def user?
    has_role?(User::Roles::USER)
  end

  private

  def assign_default_role
    add_role(User::Roles::USER) if roles.blank?
  end

  class Roles < User
    ADMIN = :admin
    DOCTOR = :doctor
    HEALTH_COACH = :health_coach
    USER = :user

    ROLES = [ADMIN, DOCTOR, HEALTH_COACH, USER].freeze
    FULL_ACCESS_ROLES = [ADMIN, DOCTOR, HEALTH_COACH].freeze
  end
end
