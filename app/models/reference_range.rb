class ReferenceRange < ApplicationRecord
  belongs_to :biomarker
  has_many :lab_tests, dependent: :nullify

  validates :min_value, presence: true, numericality: true
  validates :max_value, presence: true, numericality: true
  validates :unit, presence: true
  validates :source, presence: true
end
