# frozen_string_literal: true

class BoardSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  has_many :lists

  attributes :title, :members
  attribute :list_ids, &:ordered_list_ids
  attribute :is_creator do |board, params|
    board.user_id == params[:current_user_id]
  end
  attribute :members do |board, params|
    board.members(params[:host_with_port])
  end
end
