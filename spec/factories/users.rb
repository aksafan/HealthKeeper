# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { 'password' }

    trait :user_role do
      after(:create) { |user| user.add_role('user') }
    end

    trait :doctor_role do
      after(:create) { |user| user.add_role('doctor') }
    end

    trait :admin_role do
      after(:create) { |user| user.add_role('admin') }
    end
  end
end
