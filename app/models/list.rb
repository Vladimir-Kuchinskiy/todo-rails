# frozen_string_literal: true

class List < ApplicationRecord
  include Movable

  before_create :set_position
  after_destroy :shift_positions

  has_many :cards, dependent: :destroy

  belongs_to :board, inverse_of: :lists

  validates :title, presence: true

  scope :ordered, -> { order(:position) }

  def ordered_card_ids
    cards.ordered.ids.map(&:to_s)
  end

  private

  def set_position
    self.position = entities.count
  end

  def entities
    board.lists
  end
end
