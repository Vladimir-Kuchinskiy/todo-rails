# frozen_string_literal: true

class Board < ApplicationRecord
  has_many :lists, dependent: :destroy

  belongs_to :user

  validates :title, presence: true

  def ordered_list_ids
    lists.ordered.ids.map(&:to_s)
  end
end
