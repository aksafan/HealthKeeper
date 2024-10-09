class LabTest < ApplicationRecord
  belongs_to :user
  belongs_to :biomarker
  belongs_to :reference_range
  belongs_to :recordable, polymorphic: true, touch: true

  validates :value, presence: true, numericality: true
  validates :unit, presence: true
end
