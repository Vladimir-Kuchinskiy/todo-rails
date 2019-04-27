# frozen_string_literal: true

FactoryBot.define do
  factory :user_card do
    user
    card
  end
end
