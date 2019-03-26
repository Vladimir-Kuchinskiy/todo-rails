# frozen_string_literal: true

class Profile < ApplicationRecord
  GENDERS = %w[Male Fimale].freeze

  belongs_to :user

  has_one_attached :avatar

  def avatar_url
    if avatar.attached?
      variant = avatar.variant(resize: '200x400')
      Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true)
    else
      ''
    end
  end
end
