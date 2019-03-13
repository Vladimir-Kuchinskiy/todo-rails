# frozen_string_literal: true

class Card < ApplicationRecord
  include Movable

  before_create :set_position
  after_destroy :shift_positions

  belongs_to :list, inverse_of: :cards

  validates :content, presence: true

  scope :ordered, -> { order(:position) }
  scope :bigger_than_position, ->(position) { where('position >= ?', position) }

  private

  def set_position
    self.position = entities.count unless position
  end

  def entities
    list.cards
  end
end
