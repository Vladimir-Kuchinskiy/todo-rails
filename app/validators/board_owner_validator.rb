# frozen_string_literal: true

class BoardOwnerValidator
  def self.validate_and_return_board!(params, current_user)
    new(params, current_user).validate!
  end

  def validate!
    raise(ExceptionHandler::DeleteBoardAccessDenied, Message.board_not_allowed) unless creator?

    board
  end

  private

  attr_reader :board, :current_user, :team

  def initialize(params, current_user)
    @team = Team.find_by!(id: params[:team_id])
    @board = @team.boards.find_by!(id: params[:id])
    @current_user = current_user
  end

  def creator?
    team.creator?(current_user)
  end
end
