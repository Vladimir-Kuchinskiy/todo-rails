# frozen_string_literal: true

class Profile < ApplicationRecord
  GENDERS = %w[Male Fimale].freeze

  belongs_to :user

  has_one_attached :avatar
end
