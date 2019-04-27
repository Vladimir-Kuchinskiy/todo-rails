# frozen_string_literal: true

class Card < ApplicationRecord
  include Movable

  before_create :set_position
  after_destroy :shift_positions

  belongs_to :list, inverse_of: :cards
  has_many   :user_cards, dependent: :destroy

  delegate :board, to: :list

  validates :content, presence: true

  scope :ordered, -> { order(:position) }
  scope :bigger_than_position, ->(position) { where('position >= ?', position) }

  def assign(user)
    UserCard.create(card_id: id, user_id: user.id)
  end

  def unassign(user)
    UserCard.find_by!(user_id: user.id, card_id: id).destroy
  end

  private

  def set_position
    self.position = entities.count unless position
  end

  def entities
    list.cards
  end
end
