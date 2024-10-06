class Biomarker < ApplicationRecord
  has_many :lab_tests, dependent: :destroy
  has_many :reference_ranges, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
