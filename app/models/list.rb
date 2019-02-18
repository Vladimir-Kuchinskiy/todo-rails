# frozen_string_literal: true

class List < ApplicationRecord
  before_create :set_position

  has_many :cards, dependent: :destroy

  belongs_to :board

  validates :title, presence: true

  scope :ordered, -> { order(:position) }

  def ordered_card_ids
    cards.ordered.ids
  end

  private

  def set_position
    self.position = board.lists.count
  end
end
