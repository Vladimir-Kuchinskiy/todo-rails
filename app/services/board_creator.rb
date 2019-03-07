# frozen_string_literal: true

class BoardCreator
  def self.call(params, current_user)
    new(params, current_user).call
  end

  def call
    board = current_user.boards.create!(params)
    return board unless params[:teamId]

    team = Team.find(params[:teamId])
    board.update(team_id: team.id)
    board
  end

  private

  attr_reader :params, :current_user

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end
end
