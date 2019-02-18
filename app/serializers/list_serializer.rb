# frozen_string_literal: true

class ListSerializer
  include FastJsonapi::ObjectSerializer

  has_many :cards

  belongs_to :board

  attributes :title
  attribute :cardIds, &:ordered_card_ids
end
