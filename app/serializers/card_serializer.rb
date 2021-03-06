# frozen_string_literal: true

class CardSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  belongs_to :list
  has_many   :user_cards

  attributes :content, :description
end
