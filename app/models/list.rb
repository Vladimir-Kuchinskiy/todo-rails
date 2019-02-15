# frozen_string_literal: true

class List < ApplicationRecord
  before_create :set_position

  belongs_to :board

  validates :title, presence: true

  private

  def set_position
    self.position = board.lists.count if position.nil?
  end
end
