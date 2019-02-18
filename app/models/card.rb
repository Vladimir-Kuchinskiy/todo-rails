# frozen_string_literal: true

class Card < ApplicationRecord
  before_create :set_position

  belongs_to :list

  validates :content, presence: true

  scope :ordered, -> { order(:position) }

  private

  def set_position
    self.position = list.cards.count
  end
end
