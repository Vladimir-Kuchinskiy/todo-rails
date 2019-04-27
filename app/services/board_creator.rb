# frozen_string_literal: true

class BoardCreator
  def self.call(params, current_user)
    new(params, current_user).call
  end

  def call
    if params[:team_id]
      validate!
      check_rights
      create_team_board
    else
      check_rights
      create_personal_board
    end
  end

  private

  attr_reader :params, :current_user, :team

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def create_team_board
    board = current_user.boards.create!(params)
    board.update(team_id: team.id)
    board
  end

  def create_personal_board
    current_user.boards.create!(params)
  end

  def validate!
    @team = Team.find_by!(id: params[:team_id])
    raise(ExceptionHandler::BoardAccessDenied, Message.board_not_allowed) unless creator?
  end

  def creator?
    @team.creator?(current_user)
  end

  def check_rights
    raise ExceptionHandler::NoMemberError, Message.not_member_board unless can_create_boards?
  end

  def can_create_boards?
    current_user.member? || !current_user.boards_limit_raised?(params[:team_id])
  end
end
