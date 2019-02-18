# frozen_string_literal: true

FactoryBot.define do
  factory :card do
    content { Faker::DcComics.hero }
    description { Faker::DcComics.title }
    list
  end
end
