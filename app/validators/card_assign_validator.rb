# frozen_string_literal: true

class CardAssignValidator
  def initialize(user, card)
    @user = user
    @card = card
  end

  def self.validate!(user, card)
    new(user, card).call
  end

  def call
    raise(ExceptionHandler::AssignError, Message.user_is_not_team_member) unless valid?

    true
  end

  private

  attr_reader :user, :card

  def valid?
    if card.list.board.team_id
      user_team_member?
    else
      card.list.board.owner?(user)
    end
  end

  def user_team_member?; end
end
