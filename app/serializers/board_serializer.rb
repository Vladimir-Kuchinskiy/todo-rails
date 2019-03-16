# frozen_string_literal: true

class BoardSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  has_many :lists

  attributes :title
  attribute :list_ids, &:ordered_list_ids
  attribute :is_creator do |board, params|
    board.user_id == params[:current_user_id]
  end
end
