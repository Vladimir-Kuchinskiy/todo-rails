# frozen_string_literal: true

class ListSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  has_many :cards

  belongs_to :board

  attributes :title
  attribute :card_ids, &:ordered_card_ids
end
