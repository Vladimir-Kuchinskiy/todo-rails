# frozen_string_literal: true

class List < ApplicationRecord
  include Shiftable

  before_create :set_position
  after_destroy :shift_lists_positions

  has_many :cards, dependent: :destroy

  belongs_to :board, inverse_of: :lists

  validates :title, presence: true

  scope :ordered, -> { order(:position) }

  def ordered_card_ids
    cards.ordered.ids.map(&:to_s)
  end

  def update_to_invalid_position
    update(position: board.lists.count + 10)
  end

  def update_position(position)
    update(position: position)
  end

  def insert_card(card, position)
    old_list = card.list
    old_position = card.position
    card.list_id = id
    card.position = position
    cards.bigger_than_position(position).ordered.reverse.map { |c| c.update(position: c.position + 1) }
    card.save
    old_list&.shift_cards_positions(old_position)
  end

  def shift_cards_positions(position)
    return unless cards.any?

    cards_list = cards.ordered
    return if cards_list.last.position < position

    shift_cards(cards_list, position)
  end

  def resources_between_positions(from, to)
    board.lists.between_positions(from, to)
  end

  private

  def set_position
    self.position = board.lists.count
  end

  def shift_lists_positions
    return unless board.lists.any?

    lists = board.lists.ordered
    return if lists.empty? || lists.last.position < position

    shift_lists(lists)
  end

  def shift_lists(lists)
    transaction do
      lists.map do |list|
        if list.position > position
          list.position -= 1
          list.save
        end
      end
    end
  end

  def shift_cards(cards, position)
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
