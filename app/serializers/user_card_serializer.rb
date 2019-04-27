# frozen_string_literal: true

class UserCardSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  belongs_to :card

  attributes :user_email
end
