# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    first_name { Faker::Lorem.word }
    last_name { Faker::Lorem.word }
    user
  end
end
