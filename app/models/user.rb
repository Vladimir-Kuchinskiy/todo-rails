# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :boards
  has_many :user_teams, dependent: :destroy
  has_many :teams, through: :user_teams

  validates :email, :password, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 8 }

  def profile
    { email: email }
  end

  def create_team(team_params)
    TeamCreator.call(team_params, self)
  end
end
