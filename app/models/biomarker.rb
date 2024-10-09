class Biomarker < ApplicationRecord
  has_many :lab_tests, dependent: :destroy
  has_many :reference_ranges, dependent: :destroy

  accepts_nested_attributes_for :lab_tests, :reference_ranges

  validates :name, presence: true, uniqueness: true
end
