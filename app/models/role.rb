# frozen_string_literal: true

class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles # rubocop:disable Rails/HasAndBelongsToMany

  belongs_to :resource,
             polymorphic: true,
             optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify

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
