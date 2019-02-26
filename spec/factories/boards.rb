# frozen_string_literal: true

FactoryBot.define do
  factory :board do
    title { Faker::Lorem.word }
    user
  end
end
