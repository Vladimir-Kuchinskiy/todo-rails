# frozen_string_literal: true

class BoardOwnerValidator
  def self.validate_and_return_board!(team, board, current_user)
    new(team, board, current_user).validate!
  end

  def validate!
    raise(ExceptionHandler::BoardAccessDenied, Message.board_not_allowed) unless creator?

    board
  end

  private

  attr_reader :board, :current_user, :team

  def initialize(team, board, current_user)
    @team = team
    @board = board
    @current_user = current_user
  end

  def creator?
    team.creator?(current_user)
  end
end
