# frozen_string_literal: true

class User < ApplicationRecord
  include ActionView::Helpers::TranslationHelper
  include RoleManagement
  include UserAssignment

  rolify
  resourcify

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

  def users_list
    User.all
  end

  private

  def handle_unexpected_transaction_error(error)
    errors.add(:base, t('errors.messages.unexpected_error'))
    Rails.logger.error("Unexpected error while doing transaction: #{error.message}")
  end
end
