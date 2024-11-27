# frozen_string_literal: true

class ReferenceRange < ApplicationRecord
  belongs_to :biomarker, touch: true
  has_many :lab_tests, dependent: :nullify

  validates :min_value, presence: true, numericality: true
  validates :max_value, presence: true, numericality: true
  validates :unit, presence: true
  validates :source, presence: true

  accepts_nested_attributes_for :lab_tests
end
