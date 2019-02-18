# frozen_string_literal: true

class BoardSerializer
  include FastJsonapi::ObjectSerializer

  has_many :lists

  attributes :title
  attribute :listIds, &:ordered_list_ids
end
