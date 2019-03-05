# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Name.unique.name }
  end
end
