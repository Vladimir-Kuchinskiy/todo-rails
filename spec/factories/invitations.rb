# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    creator
    receiver
    team
  end
end
