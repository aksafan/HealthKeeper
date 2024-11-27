# frozen_string_literal: true

class Measurement < ApplicationRecord
  belongs_to :user
  belongs_to :recordable, polymorphic: true

  enum :measurement_type, { height: 0, weight: 1, chest: 2, waist: 3, hips: 4, wrist: 5 }
  enum :unit, { kg: 'kg', lb: 'lb', cm: 'cm', ft: 'ft' }

  validates :value, presence: true, numericality: true
  validates :measurement_type, presence: true
  validates :unit, presence: true
  validates :source, presence: true
end
