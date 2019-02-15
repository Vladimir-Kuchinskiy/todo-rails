# frozen_string_literal: true

FactoryBot.define do
  factory :list do
    title { Faker::Movies::StarWars.character }
    board
  end
end
