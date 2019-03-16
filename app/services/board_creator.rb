# frozen_string_literal: true

class BoardCreator
  def self.call(params, current_user)
    new(params, current_user).call
  end

  def call
    if params[:team_id]
      validate!
      board = current_user.boards.create!(params)
      board.update(team_id: team.id)
      board
    else
      current_user.boards.create!(params)
    end
  end

  private

  attr_reader :params, :current_user, :team

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def validate!
    @team = Team.find_by!(id: params[:team_id])
    raise(ExceptionHandler::DeleteBoardAccessDenied, Message.board_not_allowed) unless creator?
  end

  def creator?
    @team.creator?(current_user)
  end
end
