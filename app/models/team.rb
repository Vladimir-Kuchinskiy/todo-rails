# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :boards, dependent: :nullify
  has_many :user_teams, dependent: :destroy
  has_many :users, through: :user_teams

  validates :name, presence: true

  def emails_of_users_not_in_the_team
    User.where.not(id: users.ids).map(&:email)
  end
end
