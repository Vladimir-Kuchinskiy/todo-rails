# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[creator receiver] do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
  end
end
