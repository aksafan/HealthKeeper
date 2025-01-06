# frozen_string_literal: true

FactoryBot.define do
  factory :reference_range do
    biomarker
    min_value { 70.0 }
    max_value { 99.0 }
    unit { 'mg/dL' }
    source { 'Standard Lab' }
  end
end
