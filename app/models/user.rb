# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  BOARDS_LIMIT = 5

  after_create :create_profile

  has_one :profile,           dependent: :destroy
  has_one :braintree_payment, dependent: :destroy
  has_one :subscription,      dependent: :destroy

  has_many :boards
  has_many :user_teams,           dependent: :destroy
  has_many :teams,                through: :user_teams
  has_many :invitations,          foreign_key: :creator_id
  has_many :received_invitations, foreign_key: :receiver_id, class_name: 'Invitation'

  validates :email, :password, presence: true
  validates :email,            uniqueness: true
  validates :password,         length: { minimum: 8 }

  delegate :first_name, :last_name, to: :profile

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

  def member_data(host_with_port)
    { email: email, avatarUrl: profile.avatar_url(host_with_port) }
  end

  def create_subscription(braintree_id)
    subscription&.dastroy
    Subscription.create(user_id: id, braintree_id: braintree_id)
  end

  def member?
    subscription.present? && (valid_subscription? || (subscription.destroy && false))
  end

  def boards_limit_raised?(team_id = nil)
    current_boards_count = team_id ? boards.of_team(team_id).count : boards.personal.count
    current_boards_count >= BOARDS_LIMIT
  end

  def payment_info?
    BraintreePayment.find_by(user_id: id)
  end

  private

  def create_profile
    Profile.create(user_id: id)
  end

  def valid_subscription?
    (subscription.canceled? && !subscription.expired?) || subscription.active?
  end
end
