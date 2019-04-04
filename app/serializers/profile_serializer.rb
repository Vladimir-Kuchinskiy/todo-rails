# frozen_string_literal: true

class ProfileSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
  include Rails.application.routes.url_helpers

  attributes :first_name, :last_name, :gender, :email

  attribute :avatar_url do |profile, params|
    profile.avatar_url(params[:host_with_port])
  end

  attribute :is_member, &:member?

  attribute :boards_limit do
    User::BOARDS_LIMIT
  end
end
