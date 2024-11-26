FactoryBot.define do
  factory :reference_range do |f|
    association :biomarker,
                f.min_value { 70.0 },
                f.max_value { 99.0 },
                f.unit { 'mg/dL' },
                f.source { "DILA" }
  end
end
