# frozen_string_literal: true

FactoryBot.define do
  factory :reference_range do |f|
    biomarker
    f.min_value { 70.0 }
    f.max_value { 99.0 }
    f.unit { 'mg/dL' }
    f.source { 'DILA' }
  end
end
