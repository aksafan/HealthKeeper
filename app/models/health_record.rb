class HealthRecord < ApplicationRecord
  belongs_to :user
  has_many :lab_tests, as: :recordable, dependent: :destroy
  has_many :measurements, as: :recordable, dependent: :destroy
end
