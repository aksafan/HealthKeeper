# frozen_string_literal: true

FactoryBot.define do
  factory :lab_test do
    user
    biomarker
    reference_range
    recordable factory: %i[health_record]
    value { 85.0 }
    unit { 'mg/dL' }
    notes { 'Regular checkup' }
  end
end
