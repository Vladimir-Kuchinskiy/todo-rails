# frozen_string_literal: true

class CardSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :list

  attributes :content, :description
end
