# frozen_string_literal: true

FactoryBot.define do
  factory :user do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.email { Faker::Internet.unique.email }
    f.password { 'password' }
    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
