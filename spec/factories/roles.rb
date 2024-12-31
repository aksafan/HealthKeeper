# frozen_string_literal: true

FactoryBot.define do
  factory :role do |f|
    f.name { Faker::Job.unique.position }
  end
end
