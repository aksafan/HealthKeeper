# frozen_string_literal: true

class LabTest < ApplicationRecord
  belongs_to :user
  belongs_to :biomarker
  belongs_to :recordable, polymorphic: true, touch: true
  belongs_to :reference_range

  validates :unit, presence: true
  validates :value, presence: true,
                    numericality: {
                      greater_than_or_equal_to: 0,
                      message: :must_be_nonnegative_and_numeric
                    }

  class Status
    NORMAL = :normal
    HIGH = :high
    LOW = :low

    ALL = [NORMAL, HIGH, LOW].freeze
  end

  def within_reference_range?
    return false unless value && reference_range

    value.between?(reference_range.min_value, reference_range.max_value)
  end

  def status
    return nil unless value && reference_range
    return Status::NORMAL if within_reference_range?

    value > reference_range.max_value ? Status::HIGH : Status::LOW
  end
end
