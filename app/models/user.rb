# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  BOARDS_LIMIT = 5

  after_create :create_profile

  has_one :profile,       dependent: :destroy
  has_one  :subscription, dependent: :destroy

  has_many :boards
  has_many :user_teams,           dependent: :destroy
  has_many :teams,                through: :user_teams
  has_many :invitations,          foreign_key: :creator_id
  has_many :received_invitations, foreign_key: :receiver_id, class_name: 'Invitation'

  validates :email, :password, presence: true
  validates :email,            uniqueness: true
  validates :password,         length: { minimum: 8 }

  def create_invitation(params)
    receiver = User.find_by!(email: params[:receiver_email])
    team = Team.find(params[:team_id])
    invitations.create!(team_id: team.id, receiver_id: receiver.id)
  end

  def invited?(team)
    received_invitations.find_by(id: team.invitations.ids).present?
  end

  def create_team(team_params)
    TeamCreator.call(team_params, self)
  end

  def create_subscription
    Subscription.create(user_id: id)
  end

  def member?
    return subscription.destroy && false if expired_subscription?

    subscription.present?
  end

  def boards_limit_raised?(team_id = nil)
    current_boards_count = team_id ? boards.of_team(team_id).count : boards.personal.count
    current_boards_count >= BOARDS_LIMIT
  end

  private

  def create_profile
    Profile.create(user_id: id)
  end

  def expired_subscription?
    subscription.present? && subscription.expired?
  end
end
