# frozen_string_literal: true

FactoryBot.define do
  factory :health_record do
    user
    notes { 'Morning blood test' }
  end
end
