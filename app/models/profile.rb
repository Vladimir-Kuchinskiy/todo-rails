# frozen_string_literal: true

class Profile < ApplicationRecord
  GENDERS = %w[Male Fimale].freeze

  belongs_to :user

  has_one_attached :avatar

  validates :gender, inclusion: { in: GENDERS, if: :gender? }

  delegate :email, :member?, to: :user

  def avatar_url(host_with_port)
    if avatar.attached?
      variant = avatar.variant(resize: '500x500')
      path = Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true)
      "http://#{host_with_port}#{path}"
    else
      ''
    end
  end

  def gender?
    gender.present?
  end
end
