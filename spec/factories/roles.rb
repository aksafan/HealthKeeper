# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "role_#{n}" }

    trait :user_role do
      name { 'user' }
    end

    trait :doctor_role do
      name { 'doctor' }
    end

    trait :admin_role do
      name { 'admin' }
    end
  end
end
