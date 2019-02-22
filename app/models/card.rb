# frozen_string_literal: true

class Card < ApplicationRecord
  include Shiftable

  before_create :set_position
  after_destroy :shift_cards_positions

  belongs_to :list, inverse_of: :cards

  validates :content, presence: true

  scope :ordered, -> { order(:position) }
  scope :bigger_than_position, ->(position) { where('position >= ?', position) }

  def update_to_invalid_position
    update(position: list.cards.count + 10)
  end

  def update_position(position)
    update(position: position)
  end

  def resources_between_positions(from, to)
    list.cards.between_positions(from, to)
  end

  private

  def set_position
    self.position = list.cards.count unless position
  end

  def shift_cards_positions
    return unless list.cards.any?

    cards = list.cards.ordered
    return if cards.empty? || cards.last.position < position

    shift_cards(cards)
  end

  def shift_cards(cards)
    transaction do
      cards.map do |card|
        if card.position > position
          card.position -= 1
          card.save
        end
      end
    end
  end
end
