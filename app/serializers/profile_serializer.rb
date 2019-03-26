# frozen_string_literal: true

class ProfileSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
  include Rails.application.routes.url_helpers

  attributes :first_name, :last_name, :gender

  attribute :avatar_url do |object|
    if object.avatar.attached?
      variant = object.avatar.variant(resize: '200x400')
      Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true)
    else
      ''
    end
  end
end
