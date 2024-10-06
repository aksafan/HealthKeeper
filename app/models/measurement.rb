class Measurement < ApplicationRecord
  belongs_to :user
  belongs_to :recordable, polymorphic: true

  enum measurement_type: { height: 0, weight: 1, chest: 2, waist: 3, hips: 4, wrist: 5 }

  validates :value, presence: true, numericality: true
  validates :measurement_type, presence: true
  validates :source, presence: true
end
