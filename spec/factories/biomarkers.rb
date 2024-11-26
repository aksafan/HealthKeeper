# frozen_string_literal: true

require 'faker'

biomarkers = [
  'Glucose',
  'Hemoglobin',
  'Cholesterol',
  'Triglycerides',
  'Vitamin D',
  'LDL Cholesterol',
  'HDL Cholesterol',
  'Insulin',
  'C-Reactive Protein',
  'Calcium',
  'Potassium',
  'Sodium',
  'Iron',
  'Ferritin',
  'Thyroid Stimulating Hormone (TSH)',
  'Free T4',
  'Free T3',
  'Creatinine',
  'Blood Urea Nitrogen (BUN)',
  'Alkaline Phosphatase',
  'AST (SGOT)',
  'ALT (SGPT)',
  'Bilirubin',
  'Albumin',
  'Magnesium'
]

FactoryBot.define do
  factory :biomarker do |f|
    f.name { biomarkers.sample }
  end
end
