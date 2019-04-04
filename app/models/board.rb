# frozen_string_literal: true

class Board < ApplicationRecord
  has_many :lists, dependent: :destroy

  belongs_to :user
  belongs_to :team, optional: true

  validates :title, presence: true

  scope :personal, -> { where(team_id: nil) }
  scope :of_team, ->(team_id) { where(team_id: team_id) }

  def ordered_list_ids
    lists.ordered.ids.map(&:to_s)
  end
end
